# Taller 3 Backend

API de autenticacion para la aplicacion Flutter, construida con Node.js, Express y MongoDB Atlas.

## Instalacion local

```powershell
cd backend
npm install
Copy-Item .env.example .env
npm run dev
```

Edita `.env` y reemplaza `MONGO_URI` y `JWT_SECRET` antes de iniciar el servidor.

## Endpoints

- `GET /`: verifica que la API este disponible.
- `POST /api/auth/register`: crea un usuario.
- `POST /api/auth/login`: inicia sesion y devuelve un JWT.
- `GET /api/auth/profile`: devuelve el perfil. Requiere `Authorization: Bearer <token>`.

## Despliegue en Railway

1. Sube este proyecto a GitHub.
2. En Railway crea un proyecto desde el repositorio.
3. Configura estas variables en Railway:

```text
MONGO_URI=mongodb+srv://...
JWT_SECRET=una-clave-larga-y-segura
NODE_ENV=production
```

4. Railway ejecutara `npm start`.
5. En MongoDB Atlas agrega el acceso de red necesario para Railway. Para una practica puedes usar `0.0.0.0/0`, aunque en produccion conviene restringir el acceso.
6. Prueba la URL publica de Railway agregando `/` o `/api/auth/...`.

MongoDB Atlas es una base de datos documental. Si el requisito exige estrictamente una base de datos relacional, debe cambiarse por PostgreSQL.
