use pyo3::prelude::*;

#[pymodule]
mod proxmox_backup_client {
    use std::str::FromStr;

    use pbs_api_types::Authid;
    use pbs_client::{HttpClient, HttpClientOptions};
    use pyo3::{
        exceptions::{PyRuntimeError, PyValueError},
        prelude::*,
    };

    #[pyclass]
    struct ProxmoxBackupClient {
        #[expect(dead_code)]
        client: HttpClient,
    }

    #[pymethods]
    impl ProxmoxBackupClient {
        #[new]
        #[pyo3(signature = (server, port, id, password=None))]
        pub fn new(server: &str, port: u16, id: &str, password: Option<&str>) -> PyResult<Self> {
            Ok(Self {
                client: HttpClient::new(
                    server,
                    port,
                    &Authid::from_str(id).map_err(|err| PyValueError::new_err(err.to_string()))?,
                    HttpClientOptions::default().password(password.map(ToOwned::to_owned)),
                )
                .map_err(|err| PyRuntimeError::new_err(err.to_string()))?,
            })
        }
    }
}
