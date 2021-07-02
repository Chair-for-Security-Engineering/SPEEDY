#include <stdio.h>
#include <stdlib.h>

#define Rounds 7 /* Put a number between 1 and 9 here */

unsigned char Sbox[64]      =  {0x08, 0x00, 0x09, 0x03, 0x38, 0x10, 0x29, 0x13, 0x0C, 0x0D, 0x04, 0x07, 0x30, 0x01, 0x20, 0x23, 0x1A, 0x12, 0x18, 0x32, 0x3E, 0x16, 0x2C, 0x36, 0x1C, 0x1D, 0x14, 0x37, 0x34, 0x05, 0x24, 0x27, 0x02, 0x06, 0x0B, 0x0F, 0x33, 0x17, 0x21, 0x15, 0x0A, 0x1B, 0x0E, 0x1F, 0x31, 0x11, 0x25, 0x35, 0x22, 0x26, 0x2A, 0x2E, 0x3A, 0x1E, 0x28, 0x3C, 0x2B, 0x3B, 0x2F, 0x3F, 0x39, 0x19, 0x2D, 0x3D};
unsigned char Sbox_inv[64]  =  {0x01, 0x0D, 0x20, 0x03, 0x0A, 0x1D, 0x21, 0x0B, 0x00, 0x02, 0x28, 0x22, 0x08, 0x09, 0x2A, 0x23, 0x05, 0x2D, 0x11, 0x07, 0x1A, 0x27, 0x15, 0x25, 0x12, 0x3D, 0x10, 0x29, 0x18, 0x19, 0x35, 0x2B, 0x0E, 0x26, 0x30, 0x0F, 0x1E, 0x2E, 0x31, 0x1F, 0x36, 0x06, 0x32, 0x38, 0x16, 0x3E, 0x33, 0x3A, 0x0C, 0x2C, 0x13, 0x24, 0x1C, 0x2F, 0x17, 0x1B, 0x04, 0x3C, 0x34, 0x39, 0x37, 0x3F, 0x14, 0x3B};

unsigned char RC[8][24]     = {{0x24, 0x3f, 0x6a, 0x88, 0x85, 0xa3, 0x08, 0xd3, 0x13, 0x19, 0x8a, 0x2e, 0x03, 0x70, 0x73, 0x44, 0xa4, 0x09, 0x38, 0x22, 0x29, 0x9f, 0x31, 0xd0},
                               {0x08, 0x2e, 0xfa, 0x98, 0xec, 0x4e, 0x6c, 0x89, 0x45, 0x28, 0x21, 0xe6, 0x38, 0xd0, 0x13, 0x77, 0xbe, 0x54, 0x66, 0xcf, 0x34, 0xe9, 0x0c, 0x6c},
                               {0xc0, 0xac, 0x29, 0xb7, 0xc9, 0x7c, 0x50, 0xdd, 0x3f, 0x84, 0xd5, 0xb5, 0xb5, 0x47, 0x09, 0x17, 0x92, 0x16, 0xd5, 0xd9, 0x89, 0x79, 0xfb, 0x1b},
                               {0xd1, 0x31, 0x0b, 0xa6, 0x98, 0xdf, 0xb5, 0xac, 0x2f, 0xfd, 0x72, 0xdb, 0xd0, 0x1a, 0xdf, 0xb7, 0xb8, 0xe1, 0xaf, 0xed, 0x6a, 0x26, 0x7e, 0x96},
                               {0xba, 0x7c, 0x90, 0x45, 0xf1, 0x2c, 0x7f, 0x99, 0x24, 0xa1, 0x99, 0x47, 0xb3, 0x91, 0x6c, 0xf7, 0x08, 0x01, 0xf2, 0xe2, 0x85, 0x8e, 0xfc, 0x16},
                               {0x63, 0x69, 0x20, 0xd8, 0x71, 0x57, 0x4e, 0x69, 0xa4, 0x58, 0xfe, 0xa3, 0xf4, 0x93, 0x3d, 0x7e, 0x0d, 0x95, 0x74, 0x8f, 0x72, 0x8e, 0xb6, 0x58},
                               {0x71, 0x8b, 0xcd, 0x58, 0x82, 0x15, 0x4a, 0xee, 0x7b, 0x54, 0xa4, 0x1d, 0xc2, 0x5a, 0x59, 0xb5, 0x9c, 0x30, 0xd5, 0x39, 0x2a, 0xf2, 0x60, 0x13},
                               {0xc5, 0xd1, 0xb0, 0x23, 0x28, 0x60, 0x85, 0xf0, 0xca, 0x41, 0x79, 0x18, 0xb8, 0xdb, 0x38, 0xef, 0x8e, 0x79, 0xdc, 0xb0, 0x60, 0x3a, 0x18, 0x0e}};

int get_byte_index(int index)
{
    return (int)(index/8);
}

int get_bit_index(int index)
{
    return 7-(index%8);
}

void print_state(unsigned char *state)
{
    for(int i=0; i<23; i++)
    {
        printf("0x%02X, ", state[i]);
    }
    printf("0x%02X\n\n", state[23]);
}


void AddRoundKey(unsigned char *state, unsigned char *roundkey)
{
    for(int i=0; i<24; i++)
    {
        state[i] = state[i] ^ roundkey[i];
    }
}

void SubBox(unsigned char *state)
{
    unsigned char temp_state[24] = {0};
    for(int i=0; i<32; i++)
    {
        unsigned char Sbox_in = 0;
        for(int j=0; j<6; j++)
        {
            Sbox_in ^= ((state[get_byte_index(i*6+j)] >> get_bit_index(i*6+j)) & 0x1) << (5-j);
        }
        unsigned char Sbox_out = Sbox[Sbox_in];
        for(int j=0; j<6; j++)
        {
            temp_state[get_byte_index(i*6+j)] ^= ((Sbox_out >> (5-j)) & 0x1) << get_bit_index(i*6+j);
        }
    }
    for(int i=0; i<24; i++)
    {
        state[i] = temp_state[i];
    }
}

void SubBoxInverse(unsigned char *state)
{
    unsigned char temp_state[24] = {0};
    for(int i=0; i<32; i++)
    {
        unsigned char Sbox_in = 0;
        for(int j=0; j<6; j++)
        {
            Sbox_in ^= ((state[get_byte_index(i*6+j)] >> get_bit_index(i*6+j)) & 0x1) << (5-j);
        }
        unsigned char Sbox_out = Sbox_inv[Sbox_in];
        for(int j=0; j<6; j++)
        {
            temp_state[get_byte_index(i*6+j)] ^= ((Sbox_out >> (5-j)) & 0x1) << get_bit_index(i*6+j);
        }
    }
    for(int i=0; i<24; i++)
    {
        state[i] = temp_state[i];
    }
}

void ShiftColumns(unsigned char *state)
{
    unsigned char temp_state[24] = {0};
    for(int i=0; i<32; i++)
    {
        for(int j=0; j<6; j++)
        {
            temp_state[get_byte_index(i*6+j)] ^= ((state[get_byte_index((i*6+j*7)%192)] >> get_bit_index((i*6+j*7)%192)) & 0x1) << get_bit_index(i*6+j);
        }
    }
    for(int i=0; i<24; i++)
    {
        state[i] = temp_state[i];
    }
}

void ShiftColumnsInverse(unsigned char *state)
{
    unsigned char temp_state[24] = {0};
    for(int i=0; i<32; i++)
    {
        for(int j=0; j<6; j++)
        {
            temp_state[get_byte_index((i*6+j*7)%192)] ^= ((state[get_byte_index(i*6+j)] >> get_bit_index(i*6+j) & 0x1) << get_bit_index((i*6+j*7)%192));
        }
    }
    for(int i=0; i<24; i++)
    {
        state[i] = temp_state[i];
    }
}

void MixColumnsAddRoundKeyAddRoundConstant(unsigned char *state, unsigned char *roundkeyxorroundconstant)
{
    const int alphas[] = {0, 1, 5, 9, 15, 21, 26};
    unsigned char temp_state[24] = {0};

    for(int i=0; i<32; i++)
    {
        for(int j=0; j<6; j++)
        {
            for(int k=0; k<(sizeof(alphas)/sizeof(alphas[0])); k++)
            {
                temp_state[get_byte_index(i*6+j)] ^= (((state[get_byte_index(((i+alphas[k])%32)*6+j)] >> get_bit_index(((i+alphas[k])%32)*6+j)) & 0x1) << get_bit_index(i*6+j));
            }
        }
    }
    for(int i=0; i<24; i++)
    {
        state[i] = temp_state[i] ^ roundkeyxorroundconstant[i];
    }
}

void MixColumnsAddRoundKeyAddRoundConstantInverse(unsigned char *state, unsigned char *roundkeyxorroundconstant)
{
    const int alphas[] = {0, 4, 5, 6, 7, 10, 12, 14, 15, 16, 18, 19, 20, 21, 22, 23, 24, 25, 28};
    unsigned char temp_state[24] = {0};

    for(int i=0; i<24; i++)
    {
        state[i] ^= roundkeyxorroundconstant[i];
    }

    for(int i=0; i<32; i++)
    {
        for(int j=0; j<6; j++)
        {
            for(int k=0; k<(sizeof(alphas)/sizeof(alphas[0])); k++)
            {
                temp_state[get_byte_index(i*6+j)] ^= (((state[get_byte_index(((i+alphas[k])%32)*6+j)] >> get_bit_index(((i+alphas[k])%32)*6+j)) & 0x1) << get_bit_index(i*6+j));
            }
        }
    }
    for(int i=0; i<24; i++)
    {
        state[i] = temp_state[i];
    }
}

void UpdateRoundKey(unsigned char *roundkey)
{
    unsigned char temp_state[24] = {0};
    for(int i=0; i<32; i++)
    {
        for(int j=0; j<6; j++)
        {
            temp_state[get_byte_index(i*6+j)] ^= ((roundkey[get_byte_index((7*(i*6+j)+1)%192)] >> get_bit_index((7*(i*6+j)+1)%192)) & 0x1) << get_bit_index(i*6+j);
        }
    }
    for(int j=0; j<24; j++)
    {
         roundkey[j] = temp_state[j];
    }
}

void Encrypt(const unsigned char *Plaintext, const unsigned char *Key, unsigned char *Ciphertext)
{
    // Key Schedule
    unsigned char RoundKey[24] = {0};
    unsigned char RoundKeysXORConstants[Rounds+1][24] = {{0}};
    for(int i=0; i<24; i++)
    {
        RoundKey[i] = Key[i];
        RoundKeysXORConstants[0][i] = Key[i];
    }
    for(int i=0; i<Rounds-1; i++)
    {
        UpdateRoundKey(RoundKey);
        for(int j=0; j<24; j++)
        {
            RoundKeysXORConstants[i+1][j] = RoundKey[j] ^ RC[i][j];
        }
    }
    UpdateRoundKey(RoundKey);
    for(int j=0; j<24; j++)
    {
        RoundKeysXORConstants[Rounds][j] = RoundKey[j];
    }

    // Initialize RoundState
    unsigned char RoundState[24] = {0};
    for(int i=0; i<24; i++)
        RoundState[i] = Plaintext[i];

    // Round Function
    // ARK
    AddRoundKey(RoundState, RoundKeysXORConstants[0]);
    for(int i=1; i<Rounds; i++)
    {
        // SB
        SubBox(RoundState);
        // SC
        ShiftColumns(RoundState);
        // SB
        SubBox(RoundState);
        // SC
        ShiftColumns(RoundState);
        // MC + ARK + ARC
        MixColumnsAddRoundKeyAddRoundConstant(RoundState, RoundKeysXORConstants[i]);
    }

    // Last Round
    // SB
    SubBox(RoundState);
    // SC
    ShiftColumns(RoundState);
    // SB
    SubBox(RoundState);
    // ARK
    AddRoundKey(RoundState, RoundKeysXORConstants[Rounds]);

    for(int i=0; i<24; i++)
    {
        Ciphertext[i] = RoundState[i];
    }
}


void Decrypt(const unsigned char *Ciphertext, const unsigned char *Key, unsigned char *Plaintext)
{
    // Key Schedule
    unsigned char RoundKey[24] = {0};
    unsigned char RoundKeysXORConstants[Rounds+1][24] = {{0}};
    for(int i=0; i<24; i++)
    {
        RoundKey[i] = Key[i];
        RoundKeysXORConstants[0][i] = Key[i];
    }
    for(int i=0; i<Rounds-1; i++)
    {
        UpdateRoundKey(RoundKey);
        for(int j=0; j<24; j++)
        {
            RoundKeysXORConstants[i+1][j] = RoundKey[j] ^ RC[i][j];
        }
    }
    UpdateRoundKey(RoundKey);
    for(int j=0; j<24; j++)
    {
        RoundKeysXORConstants[Rounds][j] = RoundKey[j];
    }

    // Initialize RoundState
    unsigned char RoundState[24] = {0};
    for(int i=0; i<24; i++)
        RoundState[i] = Ciphertext[i];

    // First Round (of Decryption)
    // ARK
    AddRoundKey(RoundState, RoundKeysXORConstants[Rounds]);
    // SB^-1
    SubBoxInverse(RoundState);
    // SC^-1
    ShiftColumnsInverse(RoundState);
    // SB^-1
    SubBoxInverse(RoundState);

    // Round Function
    for(int i=Rounds-1; i>0; i--)
    {
        // MC^-1 + ARK + ARC
        MixColumnsAddRoundKeyAddRoundConstantInverse(RoundState, RoundKeysXORConstants[i]);
        // SC^-1
        ShiftColumnsInverse(RoundState);
        // SB^-1
        SubBoxInverse(RoundState);
        // SC^-1
        ShiftColumnsInverse(RoundState);
        // SB^-1
        SubBoxInverse(RoundState);
    }
    // ARK
    AddRoundKey(RoundState, RoundKeysXORConstants[0]);

    for(int i=0; i<24; i++)
    {
        Plaintext[i] = RoundState[i];
    }
}

int main()
{
    unsigned char Plaintext[24] = {0xA1, 0x3A, 0x63, 0x24, 0x51, 0x07, 0x0E, 0x43, 0x82, 0xA2, 0x7F, 0x26, 0xA4, 0x06, 0x82, 0xF3, 0xFE, 0x9F, 0xF6, 0x80, 0x28, 0xD2, 0x4F, 0xDB};
    unsigned char Key[24] = {0x76, 0x4C, 0x4F, 0x62, 0x54, 0xE1, 0xBF, 0xF2, 0x08, 0xE9, 0x58, 0x62, 0x42, 0x8F, 0xAE, 0xD0, 0x15, 0x84, 0xF4, 0x20, 0x7A, 0x7E, 0x84, 0x77};
    unsigned char Ciphertext[24];

    print_state(Plaintext);
    Encrypt(Plaintext, Key, Ciphertext);
    print_state(Ciphertext);
    Decrypt(Ciphertext, Key, Plaintext);
    print_state(Plaintext);

    return 0;
}
