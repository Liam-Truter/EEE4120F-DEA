__kernel void primitive_xor_encryption(__global char* input, __global char* output, char key, int Size){

	//work item and work groups numbers
	int workItemNum = get_global_id(0); //Work item ID

        // Shift to the left with wrap
        char shifted_key = (key << (workItemNum % 8)) | ((unsigned char)key >> (8 - (workItemNum % 8)));
        // Xor with shifted key
        output[workItemNum] = input[workItemNum] ^ shifted_key;
}
