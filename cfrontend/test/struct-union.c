struct MaStructure {
    int Age;
    char Sexe;
    char Nom[12];
    float MoyenneScolaire;
    struct AutreStructure StructBis;
};

typedef struct Books {
   char title[50];
   char author[50];
   char subject[100];
   int book_id;
} Book;