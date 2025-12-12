package day12;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class Day12 {

    public static void main(String[] args) throws IOException {
        final URL resource = Day12.class.getClassLoader().getResource("day12/input.txt");
        final String lines = getContent(resource);

        List<String[]> splitSplit = new ArrayList<>();

        String[] parts = lines.split("\n\n");
        for (String s : parts) {
            splitSplit.add(s.split("\n"));
        }

        List<int[]> s = new ArrayList<>();
        for (String[] sArr : splitSplit.subList(0, splitSplit.size() - 1)) {
            int w = sArr[1].length();
            int h = sArr.length - 1;
            Set<List<Integer>> uniqueOrientations = getLists(sArr, w, h);
            s.add(new int[]{w, h, uniqueOrientations.size()});
        }

        int t = 0;
        for (String l : splitSplit.getLast()) {
            String[] partsL = l.replace("x", " ").replace(":", "").split(" ");
            int w = Integer.parseInt(partsL[0]);
            int h = Integer.parseInt(partsL[1]);
            int[] c = new int[java.util.Arrays.stream(partsL).skip(2).mapToInt(Integer::parseInt).sum()];

            int index = 0;
            for (int i = 0; i < partsL.length - 2; i++) {
                for (int j = 0; j < Integer.parseInt(partsL[i + 2]); j++) {
                    c[index] = i;
                    index++;
                }
            }

            if (sum(s, c) <= w * h) {
                t++;
            }
        }
        System.out.println(t);
    }

    private static Set<List<Integer>> getLists(final String[] sArr, final int w, final int h) {
        Set<List<Integer>> uniqueOrientations = new HashSet<>();
        for (int o = 0; o < 8; o++) {
            List<Integer> orientation = new ArrayList<>();
            for (int y = 0; y < sArr.length - 1; y++) {
                for (int x = 0; x < sArr[1].length(); x++) {
                    if (sArr[y + 1].charAt(x) == '#') {
                        int[] oriented = orient(o, x, y, w, h);
                        orientation.add(oriented[0]);
                        orientation.add(oriented[1]);
                    }
                }
            }
            uniqueOrientations.add(orientation);
        }
        return uniqueOrientations;
    }

    private static int[] orient(int o, int x, int y, int w, int h) {
        if ((o & 1) != 0) {
            x = w - 1 - x;
        }
        if ((o & 2) != 0) {
            y = h - 1 - y;
        }
        if ((o & 4) != 0) {
            int temp = x;
            x = y;
            y = temp;
        }
        return new int[]{x, y};
    }

    private static int sum(final List<int[]> s, final int[] c) {
        int total = 0;
        for (int i : c) {
            total += s.get(i)[2];
        }
        return total;
    }

    private static String getContent(final URL resource) {
        assert resource != null;
        try (var bufferedReader = new BufferedReader(new FileReader(resource.getFile()))) {
            return bufferedReader.lines().collect(Collectors.joining("\n"));
        }
        catch (final IOException e) {
            System.out.format("I/O error: %s%n", e);
        }
        System.exit(1);
        return null;
    }


}
