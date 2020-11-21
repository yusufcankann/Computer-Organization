#include <iostream>
#include <fstream>

using namespace std;

#define MAX_SIZE 256

int result_arr[MAX_SIZE];
int result_size=0;


int CheckSumPossibility(int num, int arr[], int size){
	// base cases
	if(num == 0) return 1;
	if(num < 0) return 0;
	if(size == -1) return 0;
	
	size--;
	
	if(CheckSumPossibility(num-arr[size],arr,size) != 1){
		return CheckSumPossibility(num,arr,size);
	}else{
		result_arr[result_size]=arr[size];
		result_size++;
		return 1;
	}
}

int main()
{
	int arraySize;
	int arr[MAX_SIZE];
	int num;
	int returnVal;

	cout << "Provide size of array:";
	cin >> arraySize;
	cout << endl;

	cout << "Provide target number:";
	cin >> num;
	cout << endl;
	
	cout << "Provide your array values:" << endl;
	for(int i = 0; i < arraySize; ++i)
	{
		cin >> arr[i];
	}


	returnVal = CheckSumPossibility(num, arr, arraySize);

	if(returnVal == 1)
	{
		cout << "Possible!" << endl;

		cout << "Result array:" << endl;

		for(int i=result_size-1;i>=0;i--)
			cout<<result_arr[i]<<" ";
		cout<<endl;
	}
	else
	{
		cout << "Not possible!" << endl;
	}

	return 0;
}
