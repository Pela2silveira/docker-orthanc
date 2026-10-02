# docker-orthanc

PACS de respaldo con Orthanc (estudios locales). Imagen oficial `orthancteam/orthanc:26.9.1`.

Incluye Orthanc Explorer 2, Stone Web Viewer, OHIF, Orthanc Web Viewer y DICOMweb.

## Prerequisites

docker, make

## Setup

```bash
cp docker-compose.env.example docker-compose.env
```

Editar `docker-compose.env`: usuario/password, AET, puertos.

Opcional: editar modalities en `templates/modalities.json.template` (o en `conf/modalities.json` después del primer `configure`).

## Run

```bash
make all
```

Eso crea `/var/local/orthanc/db`, genera `conf/` desde templates y levanta el contenedor.

- UI HTTP: `http://host:8042` (default)
- DICOM: puerto `4242`, AET según `AE_TITLE` (default `ORTHANC-BACKUP`)

## Targets útiles

| Target | Descripción |
|--------|-------------|
| `make configure` | Regenera `conf/orthanc.json` y el filtro Lua (no pisa `modalities.json` si ya existe) |
| `make prepare_storage` | Crea `/var/local/orthanc/db` |
| `make run` / `stop` / `start` / `restart` | Ciclo de vida |
| `make log` | Logs del contenedor |
| `make delete` | Baja el stack y borra `conf/` |
| `make delete_all` | Además borra `/var/local/orthanc` |

## Notas

- Auth HTTP desde `.env` → `RegisteredUsers` (admin + viewer).
- El Lua limita métodos distintos de GET/POST al usuario admin.
- `DicomAlwaysAllowStore` está activo (útil como backup).
- Modalities también se pueden gestionar desde Explorer (`DicomModalitiesInDatabase`).
