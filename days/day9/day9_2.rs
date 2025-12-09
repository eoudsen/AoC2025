use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

type Coordinate = (i64, i64);


fn is_point_inside_shape(point: Coordinate, shape: &Vec<Coordinate>) -> bool {
    if shape.contains(&point) {
        return true;
    }

    let mut count = 0;

    let shape_vec: Vec<&Coordinate> = shape.iter().collect();
    let n = shape_vec.len();

    for i in 0..n {
        let vertex1 = shape_vec[i];
        let vertex2 = shape_vec[(i + 1) % n];

        if (vertex1.1 > point.1) != (vertex2.1 > point.1) {
            let intersection_x = vertex1.0 + (point.1 - vertex1.1) * (vertex2.0 - vertex1.0) / (vertex2.1 - vertex1.1);

            if point.0 < intersection_x {
                count += 1;
            } else if point.0 == intersection_x {
                if vertex1.1 == vertex2.1 {
                    if (vertex1.0 <= point.0 && point.0 <= vertex2.0) || (vertex2.0 <= point.0 && point.0 <= vertex1.0) {
                        return true;
                    }
                }
            }
        }
    }

    count % 2 == 1
}

fn main() -> io::Result<()> {
    let path = Path::new("input.txt");
    let file = File::open(&path)?;
    let reader = io::BufReader::new(file);

    let mut red_tiles: HashSet<Coordinate> = HashSet::new();
    let mut border_tiles: HashSet<Coordinate> = HashSet::new();
    let mut coordinates: Vec<Coordinate> = Vec::new();

    for line in reader.lines() {
        let line = line?;
        let coords: Vec<&str> = line.split(',').collect();
        if coords.len() == 2 {
            let x = coords[0].trim().parse::<i64>().unwrap();
            let y = coords[1].trim().parse::<i64>().unwrap();
            coordinates.push((x, y));
            border_tiles.insert((x, y));
            red_tiles.insert((x, y));
        }
    }

    let count = coordinates.len();
    if count == 0 {
        return Ok(());
    }

    for i in 0..count {
        let (x1, y1) = coordinates[i];
        let (x2, y2) = coordinates[(i + 1) % count];

        if x1 == x2 {
            let (min_y, max_y) = (y1.min(y2), y1.max(y2));
            for y in min_y..=max_y {
                border_tiles.insert((x1, y));
            }
        } else if y1 == y2 {
            let (min_x, max_x) = (x1.min(x2), x1.max(x2));
            for x in min_x..=max_x {
                border_tiles.insert((x, y1));
            }
        }
    }

    let mut largest_area = 0;
    let mut result_coords = ((0, 0), (0, 0));
    let mut counter = 0;
    println!("Max: {}", coordinates.len() * coordinates.len());

    for &start in &red_tiles {
        for &end in &red_tiles {
            let (x1, y1) = start;
            let (x2, y2) = end;

            let bottom_left = (x1.min(x2), y1.min(y2));
            let top_right = (x1.max(x2), y1.max(y2));
            let area = ((top_right.0 - bottom_left.0) + 1) * ((top_right.1 - bottom_left.1) + 1);
            counter = counter + 1;
            println!("Counter: {}", counter);
            if area < largest_area {
                continue;
            }

            let mut valid_rectangle = true;

            // Check left side
            for y in bottom_left.1..=top_right.1 {
                let left_coord = (bottom_left.0, y);
                if border_tiles.contains(&left_coord) {
                    continue;
                } else {
                    let valid_coord = is_point_inside_shape(left_coord, &coordinates);

                    if valid_coord {
                        continue;
                    } else {
                        valid_rectangle = false;
                        break;
                    }
                }
            }

            if !valid_rectangle {
                continue;
            }

            // Check right side
            for y in bottom_left.1..=top_right.1 {
                let right_coord = (top_right.0, y);
                if border_tiles.contains(&right_coord) {
                    continue;
                } else {
                    let valid_coord = is_point_inside_shape(right_coord, &coordinates);

                    if valid_coord {
                        continue;
                    } else {
                        valid_rectangle = false;
                        break;
                    }
                }
            }

            if !valid_rectangle {
                continue;
            }

            // Check bottom side
            for x in bottom_left.0..=top_right.0 {
                let bottom_coord = (x, bottom_left.1);
                if border_tiles.contains(&bottom_coord) {
                    continue;
                } else {
                     let valid_coord = is_point_inside_shape(bottom_coord, &coordinates);

                    if valid_coord {
                        continue;
                    } else {
                        valid_rectangle = false;
                        break;
                    }
                }
            }

            if !valid_rectangle {
                continue;
            }

            // Check top side
            for x in bottom_left.0..=top_right.0 {
                let top_coord = (x, top_right.1);
                if border_tiles.contains(&top_coord) {
                    continue;
                } else {
                    let valid_coord = is_point_inside_shape(top_coord, &coordinates);

                    if valid_coord {
                       continue;
                    } else {
                        valid_rectangle = false;
                        break;
                    }
                }
            }

            // Validate and update largest rectangle
            if valid_rectangle && area > largest_area {
                largest_area = area;
                result_coords = ((x1, y1), (x2, y2));
            }
        }
    }

    println!("part2: {:?}", result_coords);
    println!("Area: {}", largest_area);
    Ok(())
}
