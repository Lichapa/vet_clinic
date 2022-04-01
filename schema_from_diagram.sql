CREATE TABLE patients (
id INT GENERATED ALWAYS AS IDENTITY,
name VARCHAR(50),
date_of_birth date,
PRIMARY KEY(id)
);

CREATE TABLE medical_histories (
id INT GENERATED ALWAYS AS IDENTITY,
admitted_at TIMESTMAP,
patient_id INT,
status VARCHAR(50),
PRIMARY KEY (id),
CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE treatments (
id INT GENERATED ALWAYS AS IDENTITY,
type VARCHAR(100),
name VARCHAR(100),
PRIMARY KEY (id)
);

CREATE TABLE medical_histories_treatments (
medical_history_id INT,
treatment_id INT,
CONSTRAINT fk_medical_history FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id),
CONSTRAINT fk_treatment FOREIGN KEY(treatment_id) REFERENCES treaments(id)
)

CREATE TABLE invoices (
id INT GENERATED ALWAYS AS IDENTITY,
total_amount DECIMAL(10,2),
generated_at TIMESTMAP,
payed_at TIMESTMAP,
medical_history_id INT,
PRIMARY KEY (id),
CONSTRAINT fk_medical_history FOREIGN KEY (medical_history_id) REFERENCES medical_histories(id)
);

CREATE TABLE invoice_items (
id INT GENERATED ALWAYS AS IDENTITY,
unit_price decimal,
quantity INT,
total_price decimal,
invoice_id INT,
treatment_id INT,
PRIMARY KEY (id),
CONSTRAINT fk_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id)
CONSTRAINT fk_treatment FOREIGN KEY (treatment_id) REFERENCES treatments(id)
);

CREATE INDEX idx_medical_history_id ON medical_histories_treatments (medical_history_id);
CREATE INDEX idx_treatment_id ON medical_histories_treatments (treatment_id);
CREATE INDEX idx_invoice_id ON invoices_items (invoice_id);
CREATE INDEX idx_patient ON medical_histories (patient_id);
