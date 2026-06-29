# School Administration System - CECyTE

> **Current Status:** 🚧 Design and Data Modeling Phase *(In Progress)*

A platform designed for academic records administration, school management, and admission processes across CECyTE high schools. The primary goal of this system is to centralize student data and eliminate data redundancy.

## Repository Structure

This repository contains the data architecture blueprints and technical documentation for the system:

* `/base de datos`:
    * **SQL Scripts:** DDL code for creating tables, constraints, and relationships.
    * **Diagrams:** MySQL Workbench source file containing the Entity-Relationship Diagram (ERD).
    * **Seed Data:** Scripts to populate baseline system catalogs.
* `/docs`:
    * Data Dictionary.
    * Functional & Non-Functional Requirements Specification along with business rules (Markdown)[cite: 1].
    * CECyTE Process Manual (PDF).
    * Use Case Diagram (PDF)[cite: 1].

> **Note:** The process manual covers organizational workflows section by section to provide thorough domain understanding.

## Tech Stack

* **Database Engine:** MySQL

## Database Deployment

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/TavoMtz/CECyTE---School-System.git](https://github.com/TavoMtz/CECyTE---School-System.git)
