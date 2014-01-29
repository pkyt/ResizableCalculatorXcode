//
//  CalculatorCpp.h
//  Calculator_iOS
//
//  Created by Pavlo Kytsmey on 1/27/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#ifndef Calculator_iOS_CalculatorCpp_h
#define Calculator_iOS_CalculatorCpp_h

#include <stdio.h>
#include <string>
#include <vector>
#include <algorithm>
#include <stdlib.h>
#include <sstream>
#include <math.h>

enum types {
    number = 0,
    parenthesis = 1,
    operant = 2
};

struct token {
    char tokn; // corresponds to actual charachter of token if it's not number
    double num; // corresponds to integer value of string if it's a number
    types type;   // 0 is a number
    // variable num corespond to tokn as a number
    // 1 is a parenthesis
    // 2 is a "+", "-", "*", "\"
    token(char c, double n, types t);
};


class CalculatorCpp {
    std::string _expr; // expression string
    std::vector<token> tokens; // represent division of the expr into tokens
    std::vector<token> RPNTokens; // represent RPN
    void fillTokens(); // divide the _expr (given string) into tokens
    void fillRPNTokens(); // conver tokens into RPN format
public:
    bool err;
    std::string errorMessage;
    CalculatorCpp();
    double calculate();
    void addChar(char c); // assign _expr to that given string
};

#endif
