struct MaStructure {
    int Age: 10;
    int a, b, c: 10;
    int a, b:4, d,  c: 10;
    char Sexe;
    char Nom[12];
    //float MoyenneScolaire;
    struct AutreStructure StructBis;
    Foo t;
};

typedef struct Books {
   char title[50];
   char author[50];
   char subject[100];
   int book_id;
} Book;

typedef struct linkedList {
    int count;
    struct msgNode *front;
    struct msgNode *back;
    void (*addMSG)(unsigned char *, int, struct linkedList *);
} msgList;

struct TreeNode
{
    int data;
    struct node* left;
    struct node* right;
};

typedef struct{
        char const * const Name[2];
        const int MaxValue;
        const int Type;
        const int EppromLocation;
        const int NextID;
        const int PreviousID;
} Parameters_t;