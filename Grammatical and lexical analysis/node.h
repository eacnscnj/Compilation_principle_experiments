#ifndef NODE_H
#define NODE_H

// #include <unistd.h>
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "enum.h"
extern int yylineno;
#define TRUE 1
#define FALSE 0

typedef struct node {
    int lineNo;  //  node in which line
    NodeType type;  // node type
    char* name;     //  node name
    char* val;      //  node value

    struct node* child;  //  non-terminals node first child node
    struct node* next;   //  non-terminals node next brother node

} Node;

typedef Node* pNode;

static inline pNode newNode(int lineNo, NodeType type, char* name, int argc,
                            ...) {
    pNode curNode = NULL;
    int nameLength = strlen(name) + 1;

    curNode = (pNode)malloc(sizeof(Node));

    assert(curNode != NULL);

    
    curNode->name = (char*)malloc(sizeof(char) * nameLength);

    assert(curNode->name != NULL);


    curNode->lineNo = yylineno;
    curNode->type = type;
    strncpy(curNode->name, name, nameLength);

    va_list vaList;
    va_start(vaList, argc);

    pNode tempNode = va_arg(vaList, pNode);

    curNode->child = tempNode;

    for (int i = 1; i < argc; i++) {
        tempNode->next = va_arg(vaList, pNode);
        if (tempNode->next != NULL) {
            tempNode = tempNode->next;
        }
    }

    va_end(vaList);
    return curNode;
}

static inline pNode newTokenNode(int lineNo, NodeType type, char* tokenName,
                                 char* tokenText) {
    pNode tokenNode = (pNode)malloc(sizeof(Node));
    int nameLength = strlen(tokenName) + 1;
    int textLength = strlen(tokenText) + 1;

    assert(tokenNode != NULL);

    tokenNode->lineNo = lineNo;
    tokenNode->type = type;

    tokenNode->name = (char*)malloc(sizeof(char) * nameLength);
    tokenNode->val = (char*)malloc(sizeof(char) * textLength);

    assert(tokenNode->name != NULL);
    assert(tokenNode->val != NULL);

    strncpy(tokenNode->name, tokenName, nameLength);
    strncpy(tokenNode->val, tokenText, textLength);

    tokenNode->child = NULL;
    tokenNode->next = NULL;

    return tokenNode;
}

static inline void delNode(pNode node) {
    if (node == NULL) return;
    while (node->child != NULL) {
        pNode temp = node->child;
        node->child = node->child->next;
        delNode(temp);
    }
    free(node->name);
    free(node->val);
    free(node);
    node->name = NULL;
    node->val = NULL;
    node = NULL;
}

static inline void printTreeInfo(pNode curNode, int height) {
    if (curNode == NULL) {
        return;
    }

    for (int i = 0; i < height; i++) {
        printf("  ");
    }
    printf("%s", curNode->name);
    if (curNode->type == NOT_A_TOKEN) {
        printf(" (%d)", curNode->lineNo);
    } else if (curNode->type == TOKEN_TYPE || curNode->type == TOKEN_ID ||
               curNode->type == TOKEN_INT) {
        printf(": %s", curNode->val);
    }
    printf("\n");
    printTreeInfo(curNode->child, height + 1);
    printTreeInfo(curNode->next, height);
}

#endif