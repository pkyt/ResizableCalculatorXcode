//
//  CalculatorCpp.h
//  Calculator_iOS
//
//  Created by Pavlo Kytsmey on 1/27/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#ifndef Calculator_iOS_CalculatorCpp_mm
#define Calculator_iOS_CalculatorCpp_mm

#include "CalculatorCpp.h"
#include <iostream>
#include <stdio.h>
#include <string>
#include <vector>
#include <algorithm>
#include <stdlib.h>
#include <sstream>
#include <math.h>

token::token(char c, double n, types t){
    tokn = c;
    num = n;
    type = t;
}

CalculatorCpp::CalculatorCpp(){
    _expr = "";
    err = false;
}

void CalculatorCpp::addChar(char c){
    if (err){
        err = false;
        _expr = "";
        tokens.clear();
        RPNTokens.clear();
    }
    CalculatorCpp::_expr = CalculatorCpp::_expr + c;
    //std::cout << "got here" << std::endl;
}

void CalculatorCpp::fillTokens(){
    unsigned long i = 0;
    unsigned long nextOpr = _expr.find_first_of("+-*/"); // find the operant position
    while(i < _expr.length()){
        if (err){
            break;
        }
        if ((_expr[i] == ' ')||(_expr[i] == '\0')){
            i++; // the charachter can be skipped
        }else if ((_expr[i] == ')')||(_expr[i] == '(')){
            struct token t(_expr[i], 0, parenthesis);
            tokens.push_back(t);
            i++;
        }
        else if(i == nextOpr){
            nextOpr = _expr.find_first_of("+-*/", nextOpr+1); // find the next operant position if exists
            struct token t(_expr[i], 0, operant);
            tokens.push_back(t);
            i++;
        }else if ((std::isdigit(_expr[i]))||(_expr[i] == '.')){
            if ((!std::isdigit(_expr[i]))&&(_expr[i] == '.')){
                errorMessage = "invalid expr: digit should follow dot";
                err = true;
                break;
            }
            unsigned long end = _expr.find_first_not_of("0123456789.", i); // find the end of number that hit into
            std::string strNum;
            if(end == std::string::npos){ // case if number end on end of the string
                strNum = _expr.substr(i, _expr.length());
                i = _expr.length();
            }else{
                strNum = _expr.substr(i, end);
                i = end;
            }
            std::istringstream iss(strNum);
            double num;
            iss >> num;
            struct token t('n', num, number);
            tokens.push_back(t);
        }else{
            errorMessage = "ERROR: unknown character";
            err = true;
            break;
        }
    }
}

void CalculatorCpp::fillRPNTokens(){
    std::vector<token> stack;
    for(int i = 0; i < tokens.size(); i++){
        if(err){
            break;
        }
        struct token t = tokens[i];
        if (t.type == parenthesis){
            if(t.tokn == '('){
                stack.push_back(t); // add to stack
            }else{ // means t->tokn == ')' (other cases doesn't exist)
                if(stack.size() == 0){
                    errorMessage = "invalid expr: no '(' before ')'";
                    err = true;
                    break;
                }
                while (stack[stack.size()-1].type != parenthesis) {
                    // adding operants from stack to PRNTokens until we hit the left parethisis at the top of stack
                    if(stack.size() == 1){ // if we can't hit left parenthesis => systax error
                        errorMessage = "invalid expr: no '(' before ')'";
                        err = true;
                        break;
                    }
                    if (err){
                        break;
                    }
                    RPNTokens.push_back(stack[stack.size()-1]);
                    stack.pop_back();
                }
                stack.pop_back();
            }
        }else if(t.type == number){
            RPNTokens.push_back(t);
        }else if(t.type == operant){
            bool precedence = false; // define whether t operant is higher proirity
            //(multiplication and division must to be done before addition or subtraction)
            if ((stack.size() > 0)&&(stack[stack.size()-1].type == operant)){
                if(((stack[stack.size()-1].tokn == '+')||(stack[stack.size()-1].tokn == '-'))&&((t.tokn == '*')||(t.tokn == '/'))){
                    precedence = true;
                }
            }
            if((stack.size()== 0)||(stack[stack.size()-1].type == parenthesis)||precedence){
                stack.push_back(t);
            }else{ // prioritizing the operants
                bool cont = true;
                while (cont){ // all additions and subtraction signs has to be after multiplication and division
                    // (since calculations are done by priciple "first come first served")
                    RPNTokens.push_back(stack[stack.size()-1]);
                    stack.pop_back();
                    bool prec;
                    if ((stack.size() != 0)&&(stack[stack.size()-1].type == operant)){
                        if(((stack[stack.size()-1].tokn == '+')||(stack[stack.size()-1].tokn == '-'))&&((t.tokn == '*')||(t.tokn == '/'))){
                            prec = true;
                        }else{
                            prec = false;
                        }
                    }else{
                        prec = false;
                    }
                    cont = ((stack.size() != 0)&&(stack[stack.size()-1].type != parenthesis)&&(!prec));
                }
                stack.push_back(t);
            }
        }else{
            errorMessage = "FATAL ERROR: no token type exist";
            err = true;
            break;
        }
    }
    while(stack.size() != 0){
        if(err){
            break;
        }
        if(stack[stack.size()-1].type == parenthesis){ // parenthisis cannom be left, since it needs closing
            errorMessage = "invalid expr: no ')' after '('";
            err = true;
            break;
        }
        RPNTokens.push_back(stack[stack.size()-1]);
        stack.pop_back();
    }
}

double CalculatorCpp::calculate(){
    std::cout << _expr << std::endl;
    fillTokens();
    if (err){
        return 0;
    }
    fillRPNTokens();
    if(err){
        return 0;
    }
    std::vector<double> stack;
    for(int i = 0; i < RPNTokens.size(); i++){
        
        if (RPNTokens[i].type == number){
            stack.push_back(RPNTokens[i].num);
        }else if(RPNTokens[i].type == operant){ // do the opration given on last two numbers (double) from stack
            // if there doesn't exist two numbers => sytax error
            if(RPNTokens[i].tokn == '+'){
                if(stack.size() < 2){
                    errorMessage = "invalid expr: falied on +";
                    err = true;
                    return 0;
                }else{
                    stack[stack.size()-2] = stack[stack.size()-2] + stack[stack.size()-1];
                    stack.pop_back();
                }
            }else if(RPNTokens[i].tokn == '-'){ // subtraction of second last from the last (the rule of RPN)
                if(stack.size() < 2){
                    errorMessage = "invalid expr: falied on - ";
                    err = true;
                    return 0;
                }else{
                    stack[stack.size()-2] = stack[stack.size()-2] - stack[stack.size()-1];
                    stack.pop_back();
                }
            }else if(RPNTokens[i].tokn == '*'){
                if(stack.size() < 2){
                    errorMessage = "invalid expr: falied on *";
                    err = true;
                    return 0;
                }else{
                    stack[stack.size()-2] = stack[stack.size()-2] * stack[stack.size()-1];
                    stack.pop_back();
                }
            }else if(RPNTokens[i].tokn == '/'){ // division of second last from the last (the rule of RPN)
                if(stack.size() < 2){
                    errorMessage = "invalid expr: falied on /";
                    err = true;
                    return 0;
                }else{
                    stack[stack.size()-2] = stack[stack.size()-2] / stack[stack.size()-1];
                    stack.pop_back();
                }
            }
        }else{
            errorMessage = "FATAL ERROR: types in RPN are messed up";
            err = true;
            return 0;
        }
    }
    if (stack.size() != 1){
        errorMessage = "invalid expr: many mistakes";
        err = true;
        return 0;
    }
    _expr = "";
    tokens.clear();
    RPNTokens.clear();
    token t ('n', stack[0], number);
    tokens.push_back(t);
    return stack[0];
}

#endif

