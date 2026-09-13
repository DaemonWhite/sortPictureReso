use std::collections::HashMap;
use std::fs;
use serde::{Deserialize, Serialize};
use serde_json;
use directories::ProjectDirs;

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct CoefStorage {
    coefs: HashMap<String, CoefRange>
}

#[derive(Deserialize, Serialize, Debug, Clone, Copy, PartialEq)]
pub struct CoefRange {
    min : f32,
    max : f32
}

impl CoefRange  {
    pub fn new(min: f32, max: f32) -> CoefRange {
        Self {min, max}
    }

    pub fn in_range(self, value: f32) -> bool {
        value >= self.min && value < self.max
    }

    pub fn get_min(&self) -> f32 {
        self.min
    }

    pub fn get_max(&self) -> f32 {
        self.max
    }
}

impl Default for CoefStorage {
    fn default() -> Self {
        let mut coefs = HashMap::new();
        coefs.insert("pc-standard".to_string(), CoefRange::new(1.5, 1.9));
        coefs.insert("pc-old".to_string(), CoefRange::new(0.9, 1.5));
        coefs.insert("mobile".to_string(), CoefRange::new(0.0, 0.9));

        Self { coefs }
    }
}

impl CoefStorage {

    pub fn load_or_create() -> Result<Self, Box<dyn std::error::Error>> {
        let path = Self::get_config_path()?;

        if !path.exists() {
            let default_storage = Self::default();
            default_storage.save()?;
            return Ok(default_storage);
        }

        let content = fs::read_to_string(path)?;
        let storage: Self = serde_json::from_str(&content)?;
        Ok(storage)
    }

    pub fn save(&self) -> Result<(), Box<dyn std::error::Error>> {
        let path = Self::get_config_path()?;

        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent)?;
        }

        let json = serde_json::to_string_pretty(self)?;
        fs::write(path, json)?;
        Ok(())
    }

    fn get_config_path() -> Result<std::path::PathBuf, &'static str> {
        let proj_dirs = ProjectDirs::from("", "", "pictureSorter")
            .ok_or("Impossible de récupérer le dossier de configuration")?;
        Ok(proj_dirs.config_dir().join("coefficients.json"))
    }

    pub fn categorize(&self, ratio: f32) -> Option<&str> {
        self.coefs
            .iter()
            .find(|(_, range)| range.in_range(ratio))
            .map(|(name, _)| name.as_str())
    }

    pub fn get_coef(&self, coef_name: &str) -> Option<CoefRange> {
        self.coefs.get(coef_name).copied()
    }

    pub fn add_coef(&mut self, coef_name: &str, coef_range: CoefRange) {
        self.coefs.insert(coef_name.to_string(), coef_range);
    }

}
