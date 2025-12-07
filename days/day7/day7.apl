 day7←{
     splitterCount←0

     lines←⊃⎕NGET'input.txt' 1    ⍝ Read the file, resulting in a vector of lines
     ⎕←'numRows'
     ⎕←⍴lines
     ⎕←'columns'
     ⎕←⍴⍴lines
    ⍝  ⎕←'charLists'
    ⍝  charLists←{⍵}⍣⍴lines
    ⍝  ⎕←⍴charLists

    ⍝  linescsv←⊃⎕NGET'testline.txt' 1    ⍝ Read the file, resulting in a vector of lines
    ⍝  testline←'.......S.............................^............................^.^..........................^.^.^........................^.^...^......................^.^...^.^....................^...^.....^..................^.^.^.^.^...^................'
    ⍝  ⎕←⍴testline
    ⍝  reshapedStr←testline⍴15
    ⍝  matrix←testline⍴16 15


    ⍝  matrixtest←1 2 3⍴4 5 6  ⍝ A 2x3 matrix with the values 1, 2, 3, 4, 5, 6
    ⍝  ⎕←⍴matrixtest
    ⍝  matrixtest2←⍉2 3⍴1 2 3 4 5 6
    ⍝  ⎕←⍴matrixtest2
    ⍝  matrixtest2←⍉16 15⍴(lines⍴lines)

    ⍝  lines2←'.......S.......' '...............' '.......^.......' '...............' '......^.^......' '...............' '.....^.^.^.....' '...............' '....^.^...^....' '...............' '...^.^...^.^...' '...............' '..^...^.....^..' '...............' '.^.^.^.^.^...^.' '...............'
    ⍝  matrix←lines2⍴⍨lines2


    ⍝  singleLine←''/lines
    ⍝  characters←{⍵}⍣⍴singleLine
    ⍝  matrix←⍉16 15⍴lines

    ⍝  splitLines←⍴⍤1 1⍉lines ⍝ Split based on newline characters
    ⍝  matrix←(⊃,/⍉splitLines)     ⍝ Transform into a matrix
    ⍝  fileChars←lines⍴⍨⍴lines
    ⍝  LFPositions←lines=⎕UCS 10
    ⍝  LFPositions←⌿LFPositions  ⍝ Flatten the array to 1D
    ⍝  LFPositions←LFPositions≠''  ⍝ Filter out empty strings
    ⍝  LFPositions←+LFPositions  ⍝ Convert to numeric (1 for match, 0 for no match)
    ⍝  ⎕←'LFPositions'
    ⍝  ⎕←LFPositions

    ⍝  numericArray←0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
    ⍝  lineFeedIndices←⍸numericArray


    ⍝  lineFeedIndices←⍸LFPositions
    ⍝  lineStartIndices←1+lineFeedIndices

    ⍝  split←⊂lines⍴lineStartIndices
    ⍝  ⎕←'split'
    ⍝  ⎕←split
    ⍝  matrix←⍴lines

     ⎕←'shape of matrix'
    ⍝  ⎕←⍴matrix
     rows←⍴lines
     firstRow←lines[1]
     ⎕←firstRow
     ⎕←firstRow='S'
     comparison←firstRow='S'
     comp2←comparison∧/comparison
     comp3←0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
     ⎕←'comparison and copy'
     ⎕←comparison
     ⎕←comp2
     ⎕←comp3
     startPos←⍸comp3
     indices←startPos

     {
         newIndices←∪(indices∧/charmatrix[i]='^')  ⍝ Find positions of splitters in the rowM
         indices←(newIndices-1)∪(newIndices+1)  ⍝ Add left and right positions of the splitters

         indices←indices⍴0⍴charMatrix[i]   ⍝ Ensure indices are within the column limits

         splitterCount←splitterCount+⍴newIndices
     }⍴i←2 to rows
 }