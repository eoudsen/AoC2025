import System.IO
import Data.List (sort, foldl')
import Data.Maybe (fromMaybe)

parseRange :: String -> (Int, Int)
parseRange str =
    let (startStr, endStr) = break (== '-') str
        start = read startStr
        end = read (tail endStr)
    in (start, end)

isInRange :: Int -> (Int, Int) -> Bool
isInRange n (start, end) = n >= start && n <= end

mergeRanges :: [(Int, Int)] -> [(Int, Int)]
mergeRanges [] = []
mergeRanges [r] = [r]
mergeRanges (r1:r2:rs)
    | snd r1 >= fst r2 = mergeRanges ((fst r1, max (snd r1) (snd r2)) : rs)
    | otherwise = r1 : mergeRanges (r2:rs)

main :: IO ()
main = do
    contents <- readFile "input.txt"
    let linesContent = lines contents
    let (rangesLines, numberLines) = break null linesContent
        ranges = map parseRange rangesLines
        numbers = map read (tail numberLines)

    let count = length $ filter (\n -> any (isInRange n) ranges) numbers

    let mergedRanges = mergeRanges (sort ranges)
    let totalUniqueCount = sum [snd r - fst r + 1 | r <- mergedRanges]

    putStrLn $ "part1: " ++ show count
    putStrLn $ "part2: " ++ show totalUniqueCount
