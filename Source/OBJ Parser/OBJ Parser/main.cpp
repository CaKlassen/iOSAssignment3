//
//  main.cpp
//  OBJ Parser
//
//  Created by Alexandra Kabak on 2016-01-23.
//
//  the following tutorial was used in the creation of this parser:
//  http://www.raywenderlich.com/48293/how-to-export-blender-models-to-opengl-es-part-1
//

#include <iostream>
#include <fstream>
#include <string.h>

using namespace std;

typedef struct Model{
    int vertices;
    int positions;
    int texels;
    int normals;
    int faces;
}
Model;

//read through OBJ to figure out sizes for arrays
Model getOBJinfo(string filePath)
{
    Model model = {0};
    
    //Open OBJ
    ifstream inOBJ;
    inOBJ.open(filePath);
    
    if(!inOBJ.good())
    {
        cout << "ERROR OPENING OBJ" << endl;
        exit(1);
    }
    
    //Read OBJ
    while(!inOBJ.eof())
    {
        string line;
        getline(inOBJ, line);
        string type = line.substr(0, 2);
        
        if(type.compare("v ") == 0)//v for vertex
        {
            model.positions++;
        }
        else if(type.compare("vt") == 0)//vt for vertex texel
        {
            model.texels++;
        }
        else if(type.compare("vn") == 0)//vn for vertex normal
        {
            model.normals++;
        }
        else if(type.compare("f ") == 0)//f for face
        {
            model.faces++;
        }
    }
    
    //each face contains 3 vertices
    model.vertices = model.faces*3;
    
    //Close OBJ
    inOBJ.close();
    
    return model;
}

void extractOBJdata(string filePath, float positions[][3], float texels[][2], float normals[][3], int faces[][9])
{
    //counters
    int p = 0;
    int t = 0;
    int n = 0;
    int f = 0;
    
    //Open OBJ
    ifstream inOBJ;
    inOBJ.open(filePath);
    
    if(!inOBJ.good())
    {
        cout << "ERROR OPENING OBJ FILE" << endl;
        exit(1);
    }
    
    //Read OBJ
    while (!inOBJ.eof()) {
        string line;
        getline(inOBJ, line);
        string type = line.substr(0,2);
        
        //positions
        if(type.compare("v ") == 0)
        {
            //copy the line for parsing
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            //Extract tokens
            strtok(l, " ");
            
            for(int i=0; i<3; i++)
            {
                positions[p][i] = atof(strtok(NULL, " "));
            }
            
            delete[] l;
            p++;
        }
        //Texels
        else if(type.compare("vt") == 0)
        {
            //copy the line for parsing
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            //Extract tokens
            strtok(l, " ");
            
            for(int i=0; i<2; i++)
            {
                texels[t][i] = atof(strtok(NULL, " "));
            }
            
            delete l;
            t++;
        }
        //Normals
        else if(type.compare("vn") == 0)
        {
            //copy the line for parsing
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            //Extract tokens
            strtok(l, " ");
            
            for(int i=0; i<3; i++)
            {
                normals[n][i] = atof(strtok(NULL, " "));
            }
            
            delete[] l;
            n++;
        }
        //Faces
        else if(type.compare("f ") == 0)
        {
            //copy the line for parsing
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            //Extract tokens
            strtok(l, " ");
            
            for(int i=0; i<9; i++)
            {
                faces[f][i] = atof(strtok(NULL, " /"));
            }
            
            delete[] l;
            f++;
        }
    }
    
    //Close OBJ
    inOBJ.close();
}

//Write the .h file
void writeH(string filePath, string name, Model model)
{
    //create .h file
    ofstream outH;
    outH.open(filePath);
    
    if(!outH.good())
    {
        cout << "ERROR CREATING THE .H FILE" << endl;
        exit(1);
    }
    
    //write .h file
    outH << "//.h file for model: " << name << endl;
    outH << endl;
    
    //write stats
    outH << "//Positions: " << model.positions << endl;
    outH << "//Texels: " << model.texels << endl;
    outH << "//Normals: " << model.normals << endl;
    outH << "//Faces: " << model.faces << endl;
    outH << "//Vertices: " << model.vertices << endl;
    outH << endl;
    
    //write declarations
    outH << "const int " << "Vertices;" << endl;
    outH << "const float " << "Positions[" << model.vertices*3 << "];" << endl;
    outH << "const float " << "Texels[" << model.vertices*2 << "];" << endl;
    outH << "const float " << "Normals[" << model.vertices*3 << "];" << endl;
    outH << endl;
    
    //close .h file
    outH.close();
}

void writeCvertices(string filePath, string name, Model model)
{
    //Creat .c file
    ofstream outC;
    outC.open(filePath);
    
    if(!outC.good())
    {
        cout << "ERROR CREATING .c FILE" << endl;
        exit(1);
    }
    
    //Write the .c file
    outC << "//.h file for model: " << name << endl;
    outC << endl;
    
    //write header includes
    //outC << "#include " << "\"" << name << ".h" << "\"" << endl;
    //outC << endl;
    
    //write vertices
    outC << "const int " << name << "Vertices = " << model.vertices << ";" << endl;
    outC << endl;
    
    //Close the .c file
    outC.close();
}
    

void writeCpositions(string filePath, string name, Model model, int faces[][9], float positions[][3])
{
    //Open and append to existing .c file
    ofstream outC;
    outC.open(filePath, ios::app);
    
    //Write the positions
    outC << "const float " << name << "Positions[" << model.vertices*3 << "] = " << endl;
    outC << "{" << endl;
    
    for(int i = 0; i < model.faces; i++)
    {
        int vA = faces[i][0] - 1;
        int vB = faces[i][3] - 1;
        int vC = faces[i][6] - 1;
        
        outC << positions[vA][0] << ", " << positions[vA][1] << ", " << positions[vA][2] << ", " << endl;
        outC << positions[vB][0] << ", " << positions[vB][1] << ", " << positions[vB][2] << ", " << endl;
        outC << positions[vC][0] << ", " << positions[vC][1] << ", " << positions[vC][2] << ", " << endl;
    }
    
    outC << "};" << endl;
    outC << endl;
    
    //Close the .c file
    outC.close();
}

void writeCtexels(string filePath, string name, Model model, int faces[][9], float texels[][2])
{
    //Open and append to existing .c file
    ofstream outC;
    outC.open(filePath, ios::app);
    
    //Write the texels
    outC << "const float " << name << "Texels[" << model.vertices*2 << "] = " << endl;
    outC << "{" << endl;
    
    for(int i = 0; i < model.faces; i++)
    {
        int vtA = faces[i][1] - 1;
        int vtB = faces[i][4] - 1;
        int vtC = faces[i][7] - 1;
       
        outC << texels[vtA][0] << ", " << texels[vtA][1] << ", " << endl;
        outC << texels[vtB][0] << ", " << texels[vtB][1] << ", " << endl;
        outC << texels[vtC][0] << ", " << texels[vtC][1] << ", " << endl;
    }
    
    outC << "};" << endl;
    outC << endl;
    
    //Close the .c file
    outC.close();
}

void writeCnormals(string filePath, string name, Model model, int faces[][9], float normals[][3])
{
    //Open and append to existing .c file
    ofstream outC;
    outC.open(filePath, ios::app);
    
    //write the normals
    outC << "const float " << name << "Normals[" << model.vertices*3 << "] = " << endl;
    outC << "{" << endl;
    
    for(int i = 0; i < model.faces; i++)
    {
        int vnA = faces[i][2] - 1;
        int vnB = faces[i][5] - 1;
        int vnC = faces[i][8] - 1;
        
        outC << normals[vnA][0] << ", " << normals[vnA][1] << ", " << normals[vnA][2] << ", " << endl;
        outC << normals[vnB][0] << ", " << normals[vnB][1] << ", " << normals[vnB][2] << ", " << endl;
        outC << normals[vnC][0] << ", " << normals[vnC][1] << ", " << normals[vnC][2] << ", " << endl;
    }
    
    outC << "};" << endl;
    outC << endl;
    
    //Close the .c file
    outC.close();
}



#pragma mark main method

int main(int argc, const char * argv[]) {
    // insert code here...
    //cout << "Hello, World!\n";
    
    char fn[50];
    string fileName;
    
    printf("enter the filename of the OBJ (minus the .obj extension):\n");
    fgets(fn, sizeof(fn), stdin);
    
    char* pos;
    if((pos=strchr(fn, '\n'))!=NULL)
    {
        *pos='\0';
    }
    
    fileName = fn;
    
    //files
    string nameOBJ = fileName;// argv[1];
    string filepathOBJ = "source/" + nameOBJ + ".obj";
    string filepathH = "product/" + nameOBJ + "Data.h";
    string filepathC = "product/" + nameOBJ + "Data.c";
    
    Model model = getOBJinfo(filepathOBJ);
    
    cout << endl;
    cout << "Model Info" << endl;
    cout << "Positions: " << model.positions << endl;
    cout << "Texels: " << model.texels << endl;
    cout << "Normals: " << model.normals << endl;
    cout << "Faces: " << model.faces << endl;
    cout << "Vertices: " << model.vertices << endl;
    cout << endl;
    
    float positions[model.positions][3];//XYZ coords
    float texels[model.texels][2];//UV coords
    float normals[model.normals][3];//XYZ coords
    int faces[model.faces][9];//PTN PTN PTN (Positon/Texel/Normal)
    
    extractOBJdata(filepathOBJ, positions, texels, normals, faces);//extracting the data
    
    cout << endl;
    cout << "Model Data" << endl;
    cout << "P1: " << positions[0][0] << "x " << positions[0][1] << "y " << positions[0][2] << "z " << endl;
    cout << "T1: " << texels[0][0] << "u " << texels[0][1] << "v " << endl;
    cout << "N1: " << normals[0][0] << "x " << normals[0][1] << "y " << normals[0][2] << "z " << endl;
    cout << "F1V1: " << faces[0][0] << "p " << faces[0][1] << "t " << faces[0][2] << "n " << endl;
    cout << endl;
    
    //write .h file
    //writeH(filepathH, nameOBJ, model);
    
    //write .c file
    writeCvertices(filepathH, nameOBJ, model);
    writeCpositions(filepathH, nameOBJ, model, faces, positions);
    writeCtexels(filepathH, nameOBJ, model, faces, texels);
    writeCnormals(filepathH, nameOBJ, model, faces, normals);
    
    return 0;
}
