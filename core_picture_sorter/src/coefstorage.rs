use std::collections::HashMap;


#[derive(Debug, Clone)]
pub struct CoefStorage {
    coefs: HashMap<String, CoefRange>
}

#[derive(Debug, Clone, Copy, PartialEq)]
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

impl CoefStorage {

    pub fn new() -> CoefStorage {
        let mut coefs = HashMap::new();

        coefs.insert("pc-standar".to_string(), CoefRange::new(1.5, 1.9));
        coefs.insert("pc-old".to_string(), CoefRange::new(0.9, 1.5));
        coefs.insert("mobile".to_string(), CoefRange::new(0.0, 0.9));


        Self { coefs }
    }

    pub fn get_coef(&self, coef_name: &str) -> Option<CoefRange> {
        self.coefs.get(coef_name).copied()
    }

    pub fn add_coef(&mut self, coef_name: &str, coef_range: CoefRange) {
        self.coefs.insert(coef_name.to_string(), coef_range);
    }

}
