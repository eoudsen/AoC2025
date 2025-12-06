(ns day6
  (:require [clojure.java.io :as io]
            [clojure.string :as string]))

(defn read-input-file-part1 [file-path]
  (with-open [reader (io/reader file-path)]
    (doall
      (map #(string/split (string/trim %) #"\s+") (line-seq reader)))))

(defn read-input-file-part2 [file-path]
  (with-open [reader (io/reader file-path)]
    (doall (line-seq reader))))

(defn reorder-columns [data]
  (apply map vector data))

(defn process-file [file-path]
  (let [data (read-input-file-part1 file-path)]
    (reorder-columns data)))

(defn evaluate-operation [numbers operation]
  (let [num-list (map #(Long/parseLong %) numbers)
        trim-operation (string/trim (str operation))]
    (if (= trim-operation "+")
      (reduce + num-list)
      (reduce * num-list))))

(defn process-array [array]
  (let [numbers (butlast array)
        operation (last array)]
    (evaluate-operation numbers operation)))

(defn all-lines-have-whitespace [lines index]
  (every? (fn [line]
            (or
              (>= index (count line))
              (= \space (nth line index))))
          lines))

(defn extract-values-between-whitespace [lines]
  (let [max-length (apply max (map count lines))]
    (loop [current-index 0
           result (map (fn [line] (vec [])) lines)
           last-whitespace-index 0]
      (if (< current-index max-length)
        (if (all-lines-have-whitespace lines current-index)
          (let [new-values (map #(subs % (if (= last-whitespace-index 0) last-whitespace-index (inc last-whitespace-index)) current-index) lines)]
            (recur (inc current-index)
                   (mapv #(conj %1 %2) result new-values)
                   current-index))
          (recur (inc current-index) result last-whitespace-index))
          (if (> last-whitespace-index 0)
            (let [new-values (map #(subs % (inc last-whitespace-index)) lines)]
              (mapv #(conj %1 %2) result new-values))
        result)))))

(defn build-value-array-mine-theirs [lines]
  (let [first-four-lines (take 4 (extract-values-between-whitespace lines))
        num-entries (if (empty? first-four-lines) 0 (count (first first-four-lines)))]
    (vec (for [entry-index (range num-entries)]
           (let [value (nth (nth first-four-lines 0) entry-index)
                 num-characters (count value)]
             (vec (for [char-index (range num-characters)]
                    (let [combined-value (StringBuilder.)]
                      (doseq [row-index (range 4)]
                        (let [line (nth first-four-lines row-index)]
                          (when (< char-index (count line))
                            (.append combined-value (nth (nth line entry-index) char-index)))))
                      (.toString combined-value)))))))))

(defn process-inner-list [inner-list]
    (let [cleaned (remove empty? (map #(string/replace % #"\s+" "") inner-list))]
  (map (fn [s]
         (if (string? s)
           (Integer/parseInt (string/trim s))
           (do
             (println "Unexpected value encountered:" s)
             nil)))
       cleaned)))

(defn get-columns-and-operations [data]
  (let [columns (apply map vector data)]
    [(vec (butlast columns)) (last columns)]))

(defn process-column [column operation]
  (let [cleaned-column (remove empty? (map #(string/replace % #"\s+" "") column))]
    (evaluate-operation cleaned-column operation)))

(defn process-part1 [file-path]
  (let [result (process-file file-path)
        total-sum (reduce + (map process-array result))]
    (println "part1: " total-sum)))

(defn process-part2 [file-path]
  (let [lines (read-input-file-part2 file-path)
        value-array (build-value-array-mine-theirs lines)
        data (process-file file-path)]
    (if (seq value-array)
      (let [processed-array (doall (mapv process-inner-list value-array))
           [values operations] (get-columns-and-operations data)
           results (map process-column processed-array operations)
           total-sum (reduce + results)]
           (println "part2: " total-sum)
        )
      (println "No values found in value-array!"))))

(defn -main []
  (let [file-path "input.txt"]
    (process-part1 file-path)
    (process-part2 file-path)))

(-main)
