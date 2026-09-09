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



