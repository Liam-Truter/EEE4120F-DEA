
//Author: Christopher Hill For the EEE4120F course at UCT
//Updated by: S. Winberg

#include<stdio.h>
#include<CL/cl.h>
#include<iostream>
#include<fstream>
#include<string>
#include<cstring>
#include<cmath>
#include <tuple>
#include <chrono>

using namespace std;

int main(void)
{
    string input_text = "Hello World!";
    string output_text = input_text;

    char* input_data = const_cast<char*>(input_text.c_str());
    char* output_data = const_cast<char*>(output_text.c_str());

    int Size = strlen(input_data);
    char key = 1;

	//Initialize Buffers, memory space the allows for communication between the host and the target device
    cl_mem input_text_buffer, output_text_buffer;

	cl_uint platformCount; //keeps track of the number of platforms you have installed on your device
	cl_platform_id *platforms;
	// get platform count
	clGetPlatformIDs(5, NULL, &platformCount); //sets platformCount to the number of platforms

	// get all platforms
	platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
	clGetPlatformIDs(platformCount, platforms, NULL); //saves a list of platforms in the platforms variable

	cl_platform_id platform = platforms[0]; //Select the platform you would like to use in this program (change index to do this). If you would like to see all available platforms run platform.cpp.

	//Outputs the information of the chosen platform
	char* Info = (char*)malloc(0x1000*sizeof(char));
	clGetPlatformInfo(platform, CL_PLATFORM_NAME      , 0x1000, Info, 0);
	printf("Name      : %s\n", Info);
	clGetPlatformInfo(platform, CL_PLATFORM_VENDOR    , 0x1000, Info, 0);
	printf("Vendor    : %s\n", Info);
	clGetPlatformInfo(platform, CL_PLATFORM_VERSION   , 0x1000, Info, 0);
	printf("Version   : %s\n", Info);
	clGetPlatformInfo(platform, CL_PLATFORM_PROFILE   , 0x1000, Info, 0);
	printf("Profile   : %s\n", Info);

	//***step 2*** get device ID must first get platform

	cl_device_id device; //this is your deviceID
	cl_int err;

	/* Access a device */
	//The if statement checks to see if the chosen platform uses a GPU, if not it setups the device using the CPU
	err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
	if(err == CL_DEVICE_NOT_FOUND) {
		err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &device, NULL);
	}
	printf("Device ID = %i\n",err);

	//***Step 3*** creates a context that allows devices to send and receive kernels and transfer data
	cl_context context; //This is your contextID, the line below must just run
	context = clCreateContext(NULL, 1, &device, NULL, NULL, NULL);

	//***Step 4*** get details about the kernel.cl file in order to create it (read the kernel.cl file and place it in a buffer)
	//read file in
	FILE *program_handle;
	program_handle = fopen("OpenCL/Kernel.cl", "r");

	//get program size
	size_t program_size;//, log_size;
	fseek(program_handle, 0, SEEK_END);
	program_size = ftell(program_handle);
	rewind(program_handle);

	//sort buffer out
	char *program_buffer;//, *program_log;
	program_buffer = (char*)malloc(program_size + 1);
	program_buffer[program_size] = '\0';
	fread(program_buffer, sizeof(char), program_size, program_handle);
	fclose(program_handle);

	//***Step 5*** create program from source because the kernel is in a separate file 'kernel.cl', therefore the compiler must run twice once on main and once on kernel
	cl_program program = clCreateProgramWithSource(context, 1, (const char**)&program_buffer, &program_size, NULL); //this compiles the kernels code

	//***Step 6*** build the program, this compiles the source code from above for the devices that the code has to run on (ie GPU or CPU)
	cl_int err3= clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
	printf("program ID = %i\n", err3);

	//***Step 7*** creates the kernel, this creates a kernel from one of the functions in the cl_program you just built
    cl_kernel kernel = clCreateKernel(program, "primitive_xor_encryption", &err);

	//***Step 8*** create command queue to the target device. This is the queue that the kernels get dispatched too, to get the the desired device.
	cl_command_queue_properties properties[] = {CL_QUEUE_PROPERTIES, CL_QUEUE_PROFILING_ENABLE, 0};
	cl_command_queue queue = clCreateCommandQueueWithProperties(context, device, properties, NULL);

	//***Step 9*** create data buffers for memory management between the host and the target device
    size_t global_size = Size; //total number of work items
    size_t local_size = 1; //Size of each work group
    cl_int num_groups = global_size/local_size; //number of work groups needed

	//Buffer (memory block) that both the host and target device can access
    cl_event data_upload_start, data_upload_end;
    clEnqueueMarkerWithWaitList(queue, 0, NULL, &data_upload_start);

    input_text_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, Size, input_data, &err);
    output_text_buffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, Size, output_data, &err);

	//***Step 10*** create the arguments for the kernel (link these to the buffers set above, using the pointers for the respective buffers)
    clSetKernelArg(kernel, 0, sizeof(cl_mem), &input_text_buffer);
    clSetKernelArg(kernel, 1, sizeof(cl_mem), &output_text_buffer);
    clSetKernelArg(kernel, 2, sizeof(char), &key);
    clSetKernelArg(kernel, 3, sizeof(int), &Size);
    clEnqueueMarkerWithWaitList(queue, 0, NULL, &data_upload_end);

	//***Step 11*** enqueue kernel, deploys the kernels and determines the number of work-items that should be generated to execute the kernel (global_size) and the number of work-items in each work-group (local_size).
    cl_event kernel_event;
	cl_int err4 = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_size, &local_size, 0, NULL, &kernel_event);

	printf("\nKernel check: %i \n",err4);

	//***Step 12*** Allows the host to read from the buffer object
	cl_event read_event;
	err = clEnqueueReadBuffer(queue, output_text_buffer, CL_TRUE, 0, Size, output_data, 0, NULL, &read_event);


	//This command stops the program here until everything in the queue has been run
	clFinish(queue);

	//***Step 13*** Check that the host was able to retrieve the output data from the output buffer
	std::cout << "Input:  " << input_data << std::endl;
	std::cout << "Output: " << output_data << std::endl;

    // Get timing data

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

    // Execution Times
    cl_ulong kernel_execution_time = kernel_end - kernel_start;
    cl_ulong data_transfer_time = read_end - read_start + data_upload_end_time - data_upload_start_time;

    std::cout << "Data transfer time: " << data_transfer_time << " ns" << std::endl;
    std::cout << "Kernel execution time: " << kernel_execution_time << " ns" << std::endl;

	//------------------------------------------------------------------------

	//***Step 14*** Deallocate resources
	clReleaseKernel(kernel);
	clReleaseMemObject(output_text_buffer);
	clReleaseMemObject(input_text_buffer);
	clReleaseCommandQueue(queue);
	clReleaseProgram(program);
	clReleaseContext(context);

	return 0;
}
