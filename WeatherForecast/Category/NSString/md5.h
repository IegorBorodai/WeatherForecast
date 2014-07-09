//
//  md5.h
//  iChat
//
//  Created by grigorenko on 2/3/10.
//  Copyright 2010 EasyDate. All rights reserved.
//


@import Foundation;
#define ULONG unsigned long
#define UINT4 unsigned long int 

typedef struct _md5_ctx_
	{
		ULONG  state[4];
		ULONG  count[2];
		unsigned char buffer[64];	
	}MD5_CTX,*PMD5_CTX;
void  md5_calc(unsigned char *output, const unsigned char *input, unsigned long inlen);
void MD5Init (MD5_CTX *context);
void MD5Update (MD5_CTX *context,const unsigned char *input, unsigned long inputLen);
void MD5Final (unsigned char digest[16], MD5_CTX *context);
void MD5Transform (UINT4 *state, const unsigned char block[64]);
void Encode (unsigned char *output, UINT4 *input, unsigned long len);
void Decode (UINT4 *output, const unsigned char *input, unsigned long len);
NSString *md5_ns(NSString *imput);
char *   BuffToHex(void * buff, unsigned int size,  char * out_buff);