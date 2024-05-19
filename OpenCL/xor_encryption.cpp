//Author: Liam Truter
//Modified from code provided by S. Winberg for EEE4120F

#include<stdio.h>
#include<CL/cl.h>
#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<cstring>
#include<cmath>
#include <tuple>
#include <chrono>
#include <bitset>
#include <locale>
#include <codecvt>
#include <cstdio>

using namespace std;

string bytesToString(char* array, int size) {
    std::stringstream ss;
    for (int i = 0; i < size; ++i) {
        ss << std::bitset<8>(array[i]) << endl;
    }
    return ss.str();
}

int main(void)
{
    bool verbose = false;
    bool profiling = true;
    // Input/output file
    string input_file;
    string output_file;

    cout << "Input file: ";
    cin >> input_file;

    cout << "Output file: ";
    cin >> output_file;

    // Encryption key
    int input_key;
    char key;
    cout << "8-bit key: ";
    cin >> input_key;
    key = input_key % 256;

	// Initialize buffers
    cl_mem input_text_buffer, output_text_buffer;

    // Get platform count
	cl_uint platformCount;
	cl_platform_id *platforms;

	clGetPlatformIDs(5, NULL, &platformCount);

	// Get list of platforms
	platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
	clGetPlatformIDs(platformCount, platforms, NULL);

	// Select platform
	cl_platform_id platform = platforms[0];

	// Display platform information
	if(verbose){
        char* Info = (char*)malloc(0x1000*sizeof(char));
        clGetPlatformInfo(platform, CL_PLATFORM_NAME,    0x1000, Info, 0);
        printf("Name   : %s\n", Info);
        clGetPlatformInfo(platform, CL_PLATFORM_VENDOR,  0x1000, Info, 0);
        printf("Vendor : %s\n", Info);
        clGetPlatformInfo(platform, CL_PLATFORM_VERSION, 0x1000, Info, 0);
        printf("Version: %s\n", Info);
        clGetPlatformInfo(platform, CL_PLATFORM_PROFILE, 0x1000, Info, 0);
        printf("Profile: %s\n", Info);
	}


	// Get Device
	cl_device_id device;
	cl_int err;

	// Set up device as GPU or CPU
	err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
	if(err == CL_DEVICE_NOT_FOUND) {
		err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);
	}

	// Display device ID
	if(verbose){
        printf("Device ID = %i\n",err);
	}

	// Create context
	cl_context context;
	context = clCreateContext(NULL, 1, &device, NULL, NULL, NULL);

	// Read OpenCL kernel
	FILE *program_handle;
	program_handle = fopen("OpenCL/Kernel.cl", "r");

	// Get kernel size
	size_t program_size;
	fseek(program_handle, 0, SEEK_END);
	program_size = ftell(program_handle);
	rewind(program_handle);

	// Move program into buffer
	char *program_buffer;
	program_buffer = (char*)malloc(program_size + 1);
	program_buffer[program_size] = '\0';
	fread(program_buffer, sizeof(char), program_size, program_handle);
	fclose(program_handle);

	// Compile and build kernel
	cl_program program = clCreateProgramWithSource(context, 1, (const char**)&program_buffer, &program_size, NULL);
	cl_int err3= clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
	// Display program ID
	if(verbose){
        printf("program ID = %i\n", err3);
	}

	// Get kernel function
    cl_kernel kernel = clCreateKernel(program, "primitive_xor_encryption", &err);

	// Create command queue
	cl_command_queue_properties properties[] = {CL_QUEUE_PROPERTIES, CL_QUEUE_PROFILING_ENABLE, 0};
	cl_command_queue queue = clCreateCommandQueueWithProperties(context, device, properties, NULL);

    // Start timer
    auto start = std::chrono::high_resolution_clock::now();

    // Read input file
	std::ifstream file(input_file, std::ios::binary | std::ios::ate); // Open the file in binary mode and seek to the end
    if (!file.is_open()) {
        std::cerr << "Error opening file." << std::endl;
        return 1;
    }

    // Determine the size of the file
    std::streampos Size = file.tellg();
    file.seekg(0, std::ios::beg);

    // Allocate memory to hold the file contents
    char* input_data = new char[Size];
    char* output_data = new char[Size];
    // Read the contents of the file into the allocated memory
    file.read(input_data, Size);
    file.close();

    // Calculate work groups
    size_t global_size = Size;                  // Number of Work Items
    size_t local_size = 1;                      // Size of Work Groups
    cl_int num_groups = global_size/local_size; // Number of Work Groups

	// Start tracking data upload time
    cl_event data_upload_start, data_upload_end;
    clEnqueueMarkerWithWaitList(queue, 0, NULL, &data_upload_start);

    // Upload data buffers
    input_text_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, Size, input_data, &err);
    output_text_buffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, Size, output_data, &err);

	// Set kernel arguments
    clSetKernelArg(kernel, 0, sizeof(cl_mem), &input_text_buffer);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), &output_text_buffer);
    clSetKernelArg(kernel, 2, sizeof(char), &key);
    clSetKernelArg(kernel, 3, sizeof(int), &Size);
    clEnqueueMarkerWithWaitList(queue, 0, NULL, &data_upload_end); // end of data upload

	// Execute Kernel
    cl_event kernel_event;
	cl_int err4 = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_size, &local_size, 0, NULL, &kernel_event);

    // Print kernel exit status
    if(verbose){
        printf("\nKernel check: %i \n",err4);
    }

	// Read output from kernel
	cl_event read_event;
	err = clEnqueueReadBuffer(queue, output_text_buffer, CL_TRUE, 0, Size, output_data, 0, NULL, &read_event);


	//This command stops the program here until everything in the queue has been run
	clFinish(queue);

	// Open file for write
    std::ofstream outputFile(output_file, std::ios::binary);
    if (!outputFile.is_open()) {
        std::cerr << "Error opening output file." << std::endl;
        return 1;
    }

    // UTF-8 Encoding
    //outputFile << "\xEF\xBB\xBF"; // UTF-8 BOM

    // Write the contents of the input buffer to the output file
    outputFile.write(output_data, Size);
    outputFile.close();

    // Calculate final processing time
    auto end = std::chrono::high_resolution_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start);

	// Display input/output data
	//std::cout << "Input:\n" << bytesToString(input_data,Size);
	//std::cout << "Output:\n" << bytesToString(output_data,Size);

    // Get timing data:
    // Data upload time
    cl_ulong data_upload_start_time, data_upload_end_time;
    clGetEventProfilingInfo(data_upload_start, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &data_upload_start_time, NULL);
    clGetEventProfilingInfo(data_upload_end, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &data_upload_end_time, NULL);

    // Kernel execution and read event
    cl_ulong kernel_start, kernel_end, read_start, read_end;
    clGetEventProfilingInfo(kernel_event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &kernel_start, NULL);
    clGetEventProfilingInfo(kernel_event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &kernel_end, NULL);
    clGetEventProfilingInfo(read_event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &read_start, NULL);
    clGetEventProfilingInfo(read_event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &read_end, NULL);

    // Execution Time
    cl_ulong kernel_execution_time = kernel_end - kernel_start;
    // Data transfer time (upload + download)
    cl_ulong data_transfer_time = read_end - read_start + data_upload_end_time - data_upload_start_time;

    // Display times (in ms)
    if(profiling){
        std::cout << "Elapsed: " << ((float)elapsed.count())/1000000 << " ms" << std::endl;
        std::cout << "Data transfer time: " << ((float)data_transfer_time)/1000000 << " ms" << std::endl;
        std::cout << "Kernel execution time: " << ((float)kernel_execution_time)/1000000 << " ms" << std::endl;
    }

	// Deallocate resources
	clReleaseKernel(kernel);
	clReleaseMemObject(output_text_buffer);
	clReleaseMemObject(input_text_buffer);
	clReleaseCommandQueue(queue);
	clReleaseProgram(program);
	clReleaseContext(context);

	return 0;
}
