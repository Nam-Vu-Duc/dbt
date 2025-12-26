# ADP Transformation Pipeline
## 📁 Project Structure

```
adp-transformation-pipeline/
├── README.md                     # Project documentation
│
├── dbt/                          # Main dbt project
│   ├── dbt_project.yml          # Project configuration
│   ├── profiles.yml             # Database connection profiles
│   ├── packages.yml             # dbt package dependencies
│   ├── package-lock.yml         # Locked package versions
│   │
│   ├── models/                  # Data models (3-layer architecture)
│   │   ├── raw/                 # Raw data layer (views from source)
│   │   │   ├── schema.yml       # Raw layer schema definitions
│   │   │   └── tables/          # Source tables (raw data, unmodified)
│   │   │
│   │   ├── refined/             # Refined data layer (staging, transformations)
│   │   │   ├── schema.yml       # Refined layer schema definitions
│   │   │   ├── tables/
│   │   │   │   └── refined_patients.sql
│   │   │   └── views/
│   │   │       └── stg_patients.sql    # Staging views (cleaned, deduplicated)
│   │   │
│   │   └── enterprise/          # Enterprise layer (aggregations, summaries)
│   │       ├── schema.yml       # Enterprise layer schema definitions
│   │       ├── tables/
│   │       │   └── enterprise_patients.sql
│   │       └── views/           # Business-ready reports
│   │
│   ├── tests/                   # Data quality tests (by layer)
│   │   ├── raw/                 # Raw data validation tests
│   │   │   ├── test_age_valid_range.sql
│   │   │   ├── test_patient_id_format.sql
│   │   │   ├── test_positive_risk_scores.sql
│   │   │   └── test_raw_patients_not_null.sql
│   │   │
│   │   ├── refined/             # Refined data integrity tests
│   │   │   └── test_refined_patients_no_duplicates.sql
│   │   │
│   │   └── enterprise/          # Summary table validation tests
│   │       ├── test_patient_cancer_risk_has_data.sql
│   │       └── test_pct_of_total_equals_100.sql
│   │
│   ├── seeds/                   # Static reference data (CSV files)
│   │   ├── properties.yml       # Seed properties and configurations
│   │   └── mapping/
│   │       └── gender.csv       # Gender lookup table
│   │
│   ├── macros/                  # Reusable SQL/Jinja templates
│   │   ├── clean_column_names.sql
│   │   ├── generate_schema_name.sql
│   │   └── log_dbt_execution.sql
│   │
│   ├── analyses/                # Ad-hoc queries and analysis
│   ├── dbt_packages/            # Installed dbt packages (dbt_utils, etc.)
│   │   └── dbt_utils/           # dbt utility functions
│   │
│   ├── logs/                    # dbt execution logs
│   └── target/                  # Compiled SQL and run results
│       ├── compiled/            # Compiled SQL files
│       ├── run/                 # Executed models and tests
│       ├── manifest.json        # dbt project metadata
│       ├── graph.gpickle        # Project dependency graph
│       └── run_results.json     # Execution results summary
│
├── pipeline/                     # Python orchestration layer
│   └── [orchestration configs]  # DAG definitions, requirements, etc.
│
└── logs/                        # Application and execution logs
```

## 🔧 Configuration Files

### `dbt_project.yml`
Defines project metadata, model paths, target directory, and layer-specific configurations:
```yaml
models:
  adp:
    raw:
      materialized: table
      schema: raw
    refined:
      materialized: table
      schema: refined
    enterprise:
      materialized: table
      schema: enterprise
```

## 🚀 Key dbt Commands

### Setup
```bash
# Install dbt and dependencies
pip install dbt-fabric
dbt deps
```

### Development
```bash
# Run all models
dbt run

# Run specific model
dbt run --select stg_patients

# Run specific layer
dbt run --select raw
dbt run --select refined
dbt run --select enterprise

# Run with full refresh (drop and recreate)
dbt run --full-refresh

# Compile models without executing
dbt parse
```

### Testing
```bash
# Run all tests
dbt test

# Run tests for specific layer
dbt test --select tag:raw
dbt test --select tag:refined
dbt test --select tag:enterprise

# Run specific test
dbt test --select test_patient_id_format
```

### Target-Specific Commands
```bash
dbt run --target warehouse
dbt test --target warehouse
```

### Debugging & Documentation
```bash
# Generate dbt documentation
dbt docs generate

# Serve documentation locally
dbt docs serve

# Debug mode (verbose output)
dbt run --debug

# List all models
dbt list

# List models in a specific layer
dbt list --select raw
dbt list --select refined
```

## 📊 Data Architecture

### Three-Layer Transformation Pipeline

#### 1. **Raw Layer** (`raw/`)
- **Materialization**: Views
- **Schema**: `raw`
- **Purpose**: Direct views from source data systems
- **Key Tables**: Source system tables (unmodified)
- **Tests**: Data validation at source
  - `test_age_valid_range.sql` - Ensures age values are within acceptable range
  - `test_patient_id_format.sql` - Validates patient ID formatting
  - `test_positive_risk_scores.sql` - Ensures risk scores are positive
  - `test_raw_patients_not_null.sql` - Validates mandatory fields

#### 2. **Refined Layer** (`refined/`)
- **Materialization**: Tables
- **Schema**: `refined`
- **Purpose**: Cleaned, transformed, and deduplicated data ready for analytics
- **Key Tables & Views**:
  - `refined_patients.sql` - Deduplicated patient table
  - `stg_patients.sql` - Staging view with transformations
- **Tests**: Data quality and consistency checks
  - `test_refined_patients_no_duplicates.sql` - Ensures no duplicate patient records

#### 3. **Enterprise Layer** (`enterprise/`)
- **Materialization**: Tables
- **Schema**: `enterprise` (SQL Warehouse)
- **Purpose**: Business-ready aggregated data and reports
- **Key Tables & Views**:
  - `enterprise_patients.sql` - Aggregated patient data with metrics
- **Tests**: Summary validation
  - `test_patient_cancer_risk_has_data.sql` - Validates data presence
  - `test_pct_of_total_equals_100.sql` - Ensures aggregation integrity

### Reference Data (Seeds)
- **Location**: `seeds/mapping/`
- **Load**: `dbt seed` command loads reference data into database

## ⚙️ Environment Management

## 🔄 Development Workflow

1. **Update Source**: New data arrives in raw layer
2. **Create/Update Tests**: Add tests in `tests/raw/` for data validation
3. **Transform Data**: Build refined layer models in `models/refined/`
4. **Add Tests**: Add tests in `tests/refined/` for transformation quality
5. **Aggregate**: Create enterprise layer tables in `models/enterprise/`
6. **Validate**: Add tests in `tests/enterprise/` for output validation
7. **Generate Docs**: Run `dbt docs generate` for documentation
8. **Deploy**: Commit changes and merge to main branch

## 📌 Best Practices

- **Credentials**: Store `profiles.yml` credentials securely using environment variables in production
- **Default Target**: Default target is `lakehouse`; use `--target warehouse` for SQL Warehouse runs
- **Testing**: Run tests before deploying changes - data quality is critical
- **Documentation**: Update `schema.yml` files for better insights; run `dbt docs generate` regularly
- **Source Control**: Commit all model, test, and macro changes; exclude `profiles.yml` and sensitive data

## 🚦 Common Issues & Troubleshooting

### Models not running
- Check `dbt parse` for compilation errors
- Verify `profiles.yml` has correct credentials
- Ensure Lakehouse/Warehouse connectivity

### Tests failing
- Run `dbt test --debug` to see detailed error messages
- Check test data assumptions against actual data
- Verify schema names match configuration

---

**Project Status**: Development (using sample data for implementation)
**Last Updated**: December 2024