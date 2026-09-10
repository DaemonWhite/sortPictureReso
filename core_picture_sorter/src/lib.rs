//! # core_logic
//!
//! Une librairie utilitaire pour les calculs géométriques simples.

// --- FONCTION PUBLIQUE ---
/// Calcule la distance euclidienne entre deux points (x1, y1) et (x2, y2).
///
/// # Arguments
/// * `x1` - L'abscisse du premier point.
/// * `y1` - L'ordonnée du premier point.
/// * `x2` - L'abscisse du second point.
/// * `y2` - L'ordonnée du second point.
///
/// # Returns
/// La distance calculée (un `f64`).

pub mod coefstorage;

use std::io::Read;
use std::fs::{self, File};
use std::path::PathBuf;
use image::guess_format;


pub fn search_image(path: PathBuf, recursif: bool) -> Vec<PathBuf> {
    let mut picture_paths = Vec::new();

    let entries = match fs::read_dir(&path) {
        Ok(entries) => entries,
        Err(_) => return picture_paths,
    };

    for entry in entries.flatten() {
        let entry_path = entry.path();

        if entry_path.is_file() {
            if is_image(&entry_path) {
                picture_paths.push(entry_path);
            }
        } else if recursif && entry_path.is_dir() {
            picture_paths.append(&mut search_image(entry_path, recursif));
        }
    }

    picture_paths
}

fn is_image(path: &PathBuf) -> bool {
    // Lecture des 16 premiers octets seulement (Magic Numbers)
    let mut file = match File::open(path) {
        Ok(f) => f,
        Err(_) => return false,
    };

    // Taille du buffer qui représente les 16 premier octets
    let mut buffer = [0u8; 16];
    if file.read(&mut buffer).is_err() {
        return false;
    }

    guess_format(&buffer).is_ok()
}

pub fn calculate_distance(x1: f64, y1: f64, x2: f64, y2: f64) -> f64 {
    // Formule de distance: sqrt((x2-x1)^2 + (y2-y1)^2)
    let dx = x2 - x1;
    let dy = y2 - y1;

    // On utilise la fonction `sqrt` de la bibliothèque standard
    (dx.powi(2) + dy.powi(2)).sqrt()
}

// --- STRUCTURE PUBLIQUE ---
/// Représente un point dans un espace 2D.
#[derive(Debug, Clone, Copy)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

impl Point {
    /// Crée un nouveau Point.
    pub fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}



