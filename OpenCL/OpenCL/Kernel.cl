__kernel void primitive_xor_encryption(__global char* input, __global char* output, char key, int Size){
	//work item and work groups numbers
	int workItemNum = get_global_id(0); //Work item ID

	if (workItemNum < Size){
        char shifted_key = key << (workItemNum % 8) | key >> (8 - workItemNum % 8);
        output[workItemNum] = input[workItemNum] ^ shifted_key;
        //printf("Worker: %d\t Byte: %d\tEncrypted Byte: %d", workItemNum, input[workItemNum], input[workItemNum] ^ shifted_key)
	}
}
