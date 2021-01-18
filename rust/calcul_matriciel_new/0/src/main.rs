//Hugo BERANGER - M2 MIAGE IA

use ndarray::prelude::*;
use std::env;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {

    let args: Vec<String> = env::args().collect();
    let dim: i32 = args[3].parse().unwrap();

    //println!("{:}", args[1]);
    //println!("{:}", args[2]);
    //println!("{:}", args[3]);

    let mut matrice1 = Array2::<f32>::zeros((dim as usize,dim as usize));
    let mut matrice2 = Array2::<f32>::zeros((dim as usize,dim as usize));

    let mut x: i32 = 0;
    let mut y: i32 = 0;

    let mut filename = &args[1];
    let mut file = File::open(filename).unwrap();
    let mut reader = BufReader::new(file);

    for (_t, line) in reader.lines().enumerate() {
        let line = line.unwrap();
        matrice1[[x as usize,y as usize]] = line.parse::<f32>().unwrap();
        if y == dim - 1 {
            x = x + 1;
            y = -1;
            if x == dim {
                break;
            }
        }
        y = y + 1;
    }

    filename = &args[2];
    file = File::open(filename).unwrap();
    reader = BufReader::new(file);

    x = 0;
    y = 0;

    for (_t, line) in reader.lines().enumerate() {
        let line = line.unwrap();
        matrice2[[x as usize,y as usize]] = line.parse::<f32>().unwrap();
        if y == dim - 1 {
            x = x + 1;
            y = -1;
            if x == dim {
                break;
            }
        }
        y = y + 1;
    }

    let mut produit = Array2::<f32>::zeros((dim as usize,dim as usize));

    let mut temp: f32 = 0.0;

    for x in 0..dim {
        for y in 0..dim {
            for z in 0..dim {
                //println!("{} + {} * {}",temp,matrice1[[x as usize,z as usize]],matrice2[[z as usize,y as usize]]);
                temp = temp + matrice1[[x as usize,z as usize]] * matrice2[[z as usize,y as usize]];
            }
            produit[[x as usize,y as usize]] = temp;
            temp = 0.0;
        }
    }

    //println!("{}",produit);

    println!("produit[0,0] : {:.32}", produit[[0,0]])
}