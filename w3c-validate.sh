#!/bin/bash

# W3C Validator Script
# Usage: ./w3c-validate.sh <folder_path>

# Check if folder path is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <folder_path>"
    exit 1
fi

FOLDER="$1"

# Check if folder exists
if [ ! -d "$FOLDER" ]; then
    echo "Error: Directory '$FOLDER' does not exist"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# W3C Validator URLs
HTML_VALIDATOR="https://validator.w3.org/nu/"
CSS_VALIDATOR="https://jigsaw.w3.org/css-validator/validator"

echo "========================================="
echo "W3C Validation for: $FOLDER"
echo "========================================="

# Validate HTML files
echo -e "\n${YELLOW}Validating HTML files...${NC}"
for file in "$FOLDER"/*.html "$FOLDER"/**/*.html; do
    if [ -f "$file" ]; then
        echo -e "\nChecking: $file"
        
        # Send file to W3C HTML validator
        response=$(curl -s -H "Content-Type: text/html; charset=utf-8" \
            --data-binary @"$file" \
            "${HTML_VALIDATOR}?out=json")
        
        # Check if there are errors or warnings
        errors=$(echo "$response" | grep -o '"type":"error"' | wc -l)
        warnings=$(echo "$response" | grep -o '"type":"warning"' | wc -l)
        
        if [ "$errors" -gt 0 ]; then
            echo -e "${RED}✗ $errors error(s) found${NC}"
            echo "$response" | python3 -m json.tool 2>/dev/null | grep -A 2 '"type":"error"' | head -20
        elif [ "$warnings" -gt 0 ]; then
            echo -e "${YELLOW}⚠ $warnings warning(s) found${NC}"
            echo "$response" | python3 -m json.tool 2>/dev/null | grep -A 2 '"type":"warning"' | head -10
        else
            echo -e "${GREEN}✓ Valid HTML${NC}"
        fi
    fi
done

# Validate CSS files
echo -e "\n${YELLOW}Validating CSS files...${NC}"
for file in "$FOLDER"/*.css "$FOLDER"/**/*.css; do
    if [ -f "$file" ]; then
        echo -e "\nChecking: $file"
        
        # Send file to W3C CSS validator
        response=$(curl -s -F "file=@$file" -F "output=json" "$CSS_VALIDATOR")
        
        # Check validation status
        if echo "$response" | grep -q '"validity":true'; then
            echo -e "${GREEN}✓ Valid CSS${NC}"
        else
            errors=$(echo "$response" | grep -o '"errors":\[[^]]*\]' | grep -o '"message":"[^"]*"' | wc -l)
            warnings=$(echo "$response" | grep -o '"warnings":\[[^]]*\]' | grep -o '"message":"[^"]*"' | wc -l)
            
            if [ "$errors" -gt 0 ]; then
                echo -e "${RED}✗ $errors error(s) found${NC}"
                echo "$response" | python3 -m json.tool 2>/dev/null | grep -A 3 '"errors"' | head -20
            fi
            
            if [ "$warnings" -gt 0 ]; then
                echo -e "${YELLOW}⚠ $warnings warning(s) found${NC}"
            fi
        fi
    fi
done

echo -e "\n========================================="
echo "Validation complete!"
echo "========================================="