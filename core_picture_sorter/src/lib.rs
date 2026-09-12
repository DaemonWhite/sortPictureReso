pub mod coefstorage;

use std::io::{self, Read};
use std::fs::{self, File};
use std::path::PathBuf;
use image::{guess_format, image_dimensions};
use std::collections::HashMap;


// Erreur si jamais
#[derive(Debug, Clone)]
pub struct SortAction {
    pub source: PathBuf,
    pub ratio: f32,
}

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

pub fn plan_sort(images: &[PathBuf], storage: coefstorage::CoefStorage) -> HashMap<String, Vec<SortAction>> {
    let mut plan: HashMap<String, Vec<SortAction>> = HashMap::new();

    for image in images {
        let ratio = match get_image_ratio(image) {
            Some(r) => r,
            None => continue,
        };

        let category = storage.categorize(ratio).unwrap_or("other");

        plan.entry(category.to_string())
            .or_default()
            .push(SortAction {
                source: image.clone(),
                ratio: ratio
            });
    }

    plan
}


// TODO Ajouter un système qui crée automatiquement les dossier parents
pub fn execute_plan<F>(
    plan: &HashMap<String, Vec<SortAction>>,
    move_mode: bool,
    output_path: PathBuf,
    mut on_progress: F,
) -> Result<(), io::Error>
where
    F: FnMut(&SortAction, usize, usize)
{
    let mut index = 0;
    let mut total = 0;
    for (_, actions) in plan {
        total += actions.len();
    }

    for (categorie, actions) in plan {
        let output_categorie_path = output_path.join(categorie);
        for action in actions {

                let destination = output_categorie_path.join(&action.source.file_name().unwrap());

                if let Some(parent) = destination.parent() {
                    fs::create_dir_all(parent)?;
                }

                println!("{:?}",destination);
                if move_mode {
                    fs::rename(&action.source, destination )?;
                } else {
                    fs::copy(&action.source, destination)?;
                }

                index += 1;
                on_progress(&action, index, total);
        }

    }

    Ok(())
}

pub fn get_image_ratio(path: &PathBuf) -> Option<f32> {
    let (width, height) = image_dimensions(path).ok()?;
    if height == 0 {
        return None;
    }
    Some(width as f32 / height as f32)
}
