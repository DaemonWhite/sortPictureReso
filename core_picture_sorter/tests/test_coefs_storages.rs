use core_picture_sorter::coefstorage::{CoefRange, CoefStorage};

#[cfg(test)]
mod tests {
    use super::*;

    fn assert_coef_range_eq(a: CoefRange, b: CoefRange, epsilon: f32) {
        assert!((a.get_min() - b.get_min()).abs() < epsilon, "Min mismatch. Expected {}, got {}", b.get_min(), a.get_min());
        assert!((a.get_max() - b.get_max()).abs() < epsilon, "Max mismatch. Expected {}, got {}", b.get_max(), a.get_max());
    }

    #[test]
    fn test_coef_range_new() {
        let range = CoefRange::new(1.0, 5.0);
        assert_eq!(range.get_min(), 1.0);
        assert_eq!(range.get_max(), 5.0);
    }

    #[test]
    fn test_coef_storage_new() {
        let storage = CoefStorage::new();

        let pc_standar = storage.get_coef("pc-standar");
        assert!(pc_standar.is_some());
        assert_coef_range_eq(pc_standar.unwrap(), CoefRange::new(1.5, 1.9), 0.0001);

        let pc_old = storage.get_coef("pc-old");
        assert!(pc_old.is_some());
        assert_coef_range_eq(pc_old.unwrap(), CoefRange::new(0.9, 1.5), 0.0001);

        let mobile = storage.get_coef("mobile");
        assert!(mobile.is_some());
        assert_coef_range_eq(mobile.unwrap(), CoefRange::new(0.0, 0.9), 0.0001);

        // Check that a non-existent coefficient is not present
        let missing = storage.get_coef("non-existent");
        assert!(missing.is_none());
    }

    #[test]
    fn test_coef_storage_get_coef_success() {
        let storage = CoefStorage::new();
        let result = storage.get_coef("pc-standar");
        assert!(result.is_some());
    }

    #[test]
    fn test_coef_storage_get_coef_failure() {
        let storage = CoefStorage::new();
        let result = storage.get_coef("unknown_key");
        assert!(result.is_none());
    }

    #[test]
    fn test_coef_storage_add_new_coef() {
        let mut storage = CoefStorage::new();

        let new_coef = CoefRange::new(2.0, 3.0);

        storage.add_coef("new_test_coef", new_coef);

        let result = storage.get_coef("new_test_coef");
        assert!(result.is_some());
        assert_coef_range_eq(result.unwrap(), CoefRange::new(2.0, 3.0), 0.0001);
    }

    #[test]
    fn test_coef_storage_add_overwrite_coef() {
        let mut storage = CoefStorage::new();
        let original_coef = storage.get_coef("mobile").unwrap();

        let new_coef = CoefRange::new(5.0, 6.0);

        storage.add_coef("mobile", new_coef);

        let result = storage.get_coef("mobile");
        assert!(result.is_some());
        assert_coef_range_eq(result.unwrap(), CoefRange::new(5.0, 6.0), 0.0001);

        assert_ne!(result.unwrap(), original_coef);
    }
}
