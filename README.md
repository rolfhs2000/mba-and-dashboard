production_etl/
├── .dockerignore                      # Exclude files from Docker build context
├── .env                               # Environment variables for configuration
├── .env.input                         # Template or input-specific environment variables
├── .gitignore                         # Exclude files from Git version control
├── data/                              # Data storage directory
│   ├── input/                         # Raw data files from source systems
│   └── output/                        # Processed data ready for consumption
├── Docker/                            # Multi-environment container configs
│   ├── Dockerfile_base                # Base image with shared dependencies
│   ├── Dockerfile_dev                 # Development image (includes debug tools)
│   └── Dockerfile_prod                # Production image (minimal, optimized)
├── docker-compose.yml                 # Multi-container application definition
├── docs/                              # Project documentation
│   ├── deployment.md                  # Deployment and configuration guide
│   ├── etl/                           # ETL process documentation
│   │   ├── business_rules.md          # Data transformation rules
│   │   └── pipeline_flow.md           # ETL process flow and schedules
│   ├── README.md                      # Technical documentation overview
│   └── schema/                        # Database and data model docs
│       ├── data_dictionary.csv        # Field definitions (auto-generated)
│       └── er_diagram.md              # Entity-relationship diagrams
├── logs/                              # Application logs (runtime generated)
│   ├── critical.log                   # Critical errors needing immediate attention
│   ├── error.log                      # Error messages and exceptions
│   ├── info.log                       # General process information
│   └── warning.log                    # Warning messages and potential issues
├── notebooks/                         # Jupyter notebooks for analysis
│   └── main.ipynb                     # Primary data exploration notebook
├── README.md                          # Project overview and quick start
├── requirements/                      # Environment-specific dependencies
│   ├── base.txt                       # Core dependencies (pandas, SQLAlchemy)
│   ├── dev.txt                        # Development tools (pytest, jupyter)
│   └── prod.txt                       # Production-only minimal dependencies
├── requirements.txt                   # Legacy dependency file (use requirements/)
├── scripts/                           # Automation and setup scripts
│   ├── entrypoint.sh                  # Docker container startup script
│   ├── run_tests.sh                   # Execute automated test suite
│   └── setup.sh                       # Initial project setup
├── sql/                               # SQL queries and database scripts
│   ├── queries/                       # Data extraction queries
│   │   └── get_active_users.sql       # Extract active users from source
│   └── reporting/                     # Business reporting queries
│       └── faraz_daily.sql            # Daily report generation
├── src/                               # Main application source code
│   ├── config/                        # Configuration management
│   │   ├── logging_config.py          # Logging setup and formatting
│   │   ├── settings.py                # App settings and env variables
│   │   └── __init__.py                # Python package marker
│   ├── db_connection/                 # Database connectivity layer
│   │   ├── base.py                    # Abstract connection interface
│   │   ├── builder.py                 # Connection factory pattern
│   │   ├── connectors/                # DB-specific implementations
│   │   │   ├── impala_odbc.py         # Impala via ODBC driver
│   │   │   ├── impala_thrift.py       # Impala via Thrift protocol
│   │   │   ├── mssql.py               # Microsoft SQL Server
│   │   │   ├── postgres.py            # PostgreSQL connection
│   │   │   └── __init__.py            # Package marker
│   │   ├── reader.py                  # Query execution utilities
│   │   └── __init__.py                # Package marker
│   ├── extract/                       # Data extraction from sources
│   │   ├── fetch_data.py              # Main extraction logic
│   │   └── __init__.py                # Package marker
│   ├── load/                          # Data loading to targets
│   │   ├── load_to_db.py              # Database loading operations
│   │   └── __init__.py                # Package marker
│   ├── main.py                        # Application entry point
│   ├── quality/                       # Data quality validation
│   │   ├── date_validator.py          # Date format/range validation
│   │   └── __init__.py                # Package marker
│   ├── transform/                     # Data transformation/cleaning
│   │   ├── clean_nulls.py             # Handle nulls and data cleaning
│   │   └── __init__.py                # Package marker
│   └── utils/                         # Utility functions
│       ├── x_parser.py                # x data parser
│       └── __init__.py                # Package marker
└── tests/                             # Automated testing suite
    ├── test_extract.py                # Test extraction functions
    └── test_load.py                   # Test loading functions