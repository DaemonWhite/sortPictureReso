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
        let storage = CoefStorage::default();

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
        let storage = CoefStorage::default();
        let result = storage.get_coef("pc-standar");
        assert!(result.is_some());
    }

    #[test]
    fn test_coef_storage_get_coef_failure() {
        let storage = CoefStorage::default();
        let result = storage.get_coef("unknown_key");
        assert!(result.is_none());
    }

    #[test]
    fn test_coef_storage_add_new_coef() {
        let mut storage = CoefStorage::default();

        let new_coef = CoefRange::new(2.0, 3.0);

        storage.add_coef("new_test_coef", new_coef);

        let result = storage.get_coef("new_test_coef");
        assert!(result.is_some());
        assert_coef_range_eq(result.unwrap(), CoefRange::new(2.0, 3.0), 0.0001);
    }

    #[test]
    fn test_coef_storage_add_overwrite_coef() {
        let mut storage = CoefStorage::default();
        let original_coef = storage.get_coef("mobile").unwrap();

        let new_coef = CoefRange::new(5.0, 6.0);

        storage.add_coef("mobile", new_coef);

        let result = storage.get_coef("mobile");
        assert!(result.is_some());
        assert_coef_range_eq(result.unwrap(), CoefRange::new(5.0, 6.0), 0.0001);

        assert_ne!(result.unwrap(), original_coef);
    }

    #[test]
    fn test_verify_default_is_valid() {
        let storage = CoefStorage::default();
        assert!(storage.verify().is_ok());
    }

    #[test]
    fn test_verify_contiguous_ranges_are_valid() {
        let mut storage = CoefStorage::empty();
        storage.add_coef("low", CoefRange::new(0.0, 1.0));
        storage.add_coef("high", CoefRange::new(1.0, 2.0));

        assert!(storage.verify().is_ok());
    }

    #[test]
    fn test_verify_invalid_min_max() {
        let mut storage = CoefStorage::empty();
        storage.add_coef("inverted", CoefRange::new(2.0, 1.0));
        storage.add_coef("equal", CoefRange::new(1.0, 1.0));

        let result = storage.verify();
        assert!(result.is_err());

        let errors = result.unwrap_err();
        assert_eq!(errors.len(), 2);
        assert!(errors[0].contains("min") && errors[0].contains("max"));
    }

    #[test]
    fn test_verify_overlapping_ranges() {
        let mut storage = CoefStorage::empty();
        storage.add_coef("a", CoefRange::new(0.0, 1.2));
        storage.add_coef("b", CoefRange::new(1.0, 2.0));

        let result = storage.verify();
        assert!(result.is_err());

        let errors = result.unwrap_err();
        assert_eq!(errors.len(), 1);
        assert!(errors[0].contains("Chevauchement"));
    }

    #[test]
    fn test_verify_inclusion_overlap() {
        // Test le cas où un intervalle est totalement inclus dans un autre
        let mut storage = CoefStorage::empty();
        storage.add_coef("outer", CoefRange::new(0.0, 10.0));
        storage.add_coef("inner", CoefRange::new(2.0, 5.0));

        let result = storage.verify();
        assert!(result.is_err());
    }

    #[test]
    fn test_verify_multiple_error_types() {
        let mut storage = CoefStorage::empty();
        storage.add_coef("invalid", CoefRange::new(5.0, 2.0)); // Invalide
        storage.add_coef("a", CoefRange::new(0.0, 1.5));        // Chevauche 'b'
        storage.add_coef("b", CoefRange::new(1.0, 2.0));

        let result = storage.verify();
        assert!(result.is_err());

        let errors = result.unwrap_err();
        assert_eq!(errors.len(), 2); // 1 erreur de borne + 1 erreur de chevauchement
    }
}
