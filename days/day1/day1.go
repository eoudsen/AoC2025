package main

import (
    "bufio"
    "fmt"
    "os"
    "regexp"
    "strconv"
)

func main() {
    // Specify the file name
    filename := "input.txt"

    // Open the file
    file, err := os.Open(filename)
    if err != nil {
        fmt.Printf("Error opening file: %v\n", err)
        return
    }
    defer file.Close() // Ensure the file is closed after reading

    // Create a slice to hold the lines
    var lines []string

    // Use a scanner to read the file line by line
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }

    // Check for errors during the reading process
    if err := scanner.Err(); err != nil {
        fmt.Printf("Error reading file: %v\n", err)
        return
    }

    pattern := `([L|R])(\d+)`
    re := regexp.MustCompile(pattern)
    position := 50
    numEndZero := 0
    numPassZero := 0

    for _, line := range lines {
        matches := re.FindStringSubmatch(line)

        // Check if matches were found
        if matches != nil {
            lOrR := matches[1]
            num, _ := strconv.Atoi(matches[2])
            if lOrR == "L" {
                for i:= num; i > 0; i-- {
                    position -= 1
                    if position == 0 {
                        numPassZero += 1
                    } else if position < 0 {
		                position += 100
		            }
                }
                if position == 0 {
                    numEndZero += 1
                }
            } else {
                for i := 0; i < num; i++ {
                     position += 1
                     if position > 99 {
			            position = 0
			            numPassZero += 1
                     }
                }
		        if position == 0 {
		           numEndZero += 1
		        }
            }
        } else {
            fmt.Println("No matches found.")
        }
    }
    fmt.Println("part1: ", numEndZero)
    fmt.Println("part2: ", numPassZero)
}