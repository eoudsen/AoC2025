use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() -> io::Result<()> {
    let path = "input.txt";

    let mut coordinates = Vec::new();
    let file = File::open(&path)?;
    let reader = io::BufReader::new(file);

    for line in reader.lines() {
        let line = line?;
        let parts: Vec<&str> = line.split(',').collect();
        if parts.len() == 2 {
            if let (Ok(x), Ok(y)) = (parts[0].trim().parse::<i64>(), parts[1].trim().parse::<i64>()) {
                coordinates.push((x, y));
            }
        }
    }

    let max_area_info = find_largest_rectangle(&coordinates);

    match max_area_info {
        Some((area, (x1, y1), (x2, y2))) => {
            println!("Largest Rectangle Area: {}", area);
            println!("Coordinates: ({}, {}), and ({}, {})", x1, y1, x2, y2);
        }
        None => println!("No suitable coordinates found."),
    }

    Ok(())
}

fn find_largest_rectangle(coords: &[(i64, i64)]) -> Option<(i64, (i64, i64), (i64, i64))> {
    let mut max_area = 0;
    let mut corners = ((0, 0), (0, 0));

    for &(x1, y1) in coords {
        for &(x2, y2) in coords {
            if x1 == x2 || y1 == y2 {
                continue; // Skip if they share either x or y
            }

            let width = (x2 - x1).abs() + 1;
            let height = (y2 - y1).abs() + 1;

            if let Some(area) = width.checked_mul(height) {
                if area > max_area {
                    max_area = area;
                    corners = ((x1, y1), (x2, y2));
                }
            }
        }
    }

    if max_area > 0 {
        Some((max_area, corners.0, corners.1))
    } else {
        None
    }
}
