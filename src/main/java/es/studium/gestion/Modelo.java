package es.studium.gestion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Modelo {
	private DataSource pool;
	private Connection conn = null;
	private Statement stmt = null;
	private ResultSet rs = null;

	public Modelo() {
		try {
			InitialContext ctx = new InitialContext();
			pool = (DataSource) ctx.lookup("java:comp/env/jdbc/gastos");
		} catch (Exception ex) {
			System.out.println("Error al inicializar el DataSource");
		}
	}

	private void conectar() {
		try {
			if (conn == null || conn.isClosed()) {
				conn = pool.getConnection();
			}
		} catch (SQLException e) {
			System.out.println("Error al conectar: " + e.getMessage());
		}
	}

	private void desconectar() {
		try {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			System.out.println("Error al desconectar");
		}
	}

	public int obtenerIdUsuario(String nombre) {
		int id = 0;
		String sql = "SELECT idUsuario FROM usuarios WHERE nombreUsuario = '" + nombre + "'";
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt("idUsuario");
			}
		} catch (SQLException e) {
		} finally {
			desconectar();
		}
		return id;
	}

	public boolean validarUsuario(String nombre, String clave) {
		boolean loginCorrecto = false;
		String sql = "SELECT * FROM usuarios WHERE nombreUsuario = '" + nombre + "' AND claveUsuario = SHA2('" + clave
				+ "', 256)";
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);

			if (rs.next()) {
				loginCorrecto = true;
			}
		} catch (SQLException e) {
			System.out.println("Error en validarUsuario");
		} finally {
			desconectar(); // Limpiamos todo al terminar
		}
		return loginCorrecto;
	}

	public String[] obtenerRangoFechas(int idUsuario) { // Añadimos el ID
		String[] rango = new String[2];
		String sql = "SELECT MIN(fechaCompra) as primero, MAX(fechaCompra) as ultimo "
				+ "FROM compras WHERE idUsuariosFK = " + idUsuario; // Filtro vital
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				rango[0] = rs.getString("primero");
				rango[1] = rs.getString("ultimo");
			}
		} catch (SQLException e) {
			System.out.println("Error al obtener rango: " + e.getMessage());
		} finally {
			desconectar();
		}
		return rango;
	}

	public List<Compra> obtenerTodasCompras(int idUsuario) {
		List<Compra> lista = new ArrayList<>();
		// SQL directo: sin WHERE de fechas, solo el JOIN para el nombre de la tienda
		String sql = "SELECT c.idCompra, DATE_FORMAT(c.fechaCompra, '%d/%m/%Y') AS fechaFormateada, c.importeCompra, t.nombreTienda "
				+ "FROM compras c INNER JOIN tiendas t ON c.idTiendaFK = t.idTienda " + "WHERE c.idUsuariosFK = "
				+ idUsuario + " " + "ORDER BY c.fechaCompra DESC";
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				lista.add(new Compra(rs.getInt("idCompra"), rs.getString("fechaFormateada"),
						rs.getDouble("importeCompra"), rs.getString("nombreTienda")));
			}
		} catch (SQLException e) {
			System.out.println("Error al obtener todas las compras: " + e.getMessage());
		} finally {
			desconectar();
		}
		return lista;
	}

	// También actualizamos el total para que sume TODO
	public double calcularTotalHistorico(int idUsuario) {
		double total = 0;
		String sql = "SELECT SUM(importeCompra) as total FROM compras WHERE idUsuariosFK = '" + idUsuario + "';";
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				total = rs.getDouble("total");
			}
		} catch (SQLException e) {
			System.out.println("Error al calcular total histórico");
		} finally {
			desconectar();
		}
		return total;
	}

	public void eliminarCompra(int id) {
		String sql = "DELETE FROM compras WHERE idCompra = " + id;
		try {
			conectar();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			System.out.println("Error al eliminar: " + e.getMessage());
		} finally {
			desconectar();
		}
	}

	public Compra obtenerCompraPorId(int id) {
		Compra c = null;
		
		String sql = "SELECT idCompra, fechaCompra, importeCompra, t.nombreTienda "
				+ "FROM compras c JOIN tiendas t ON c.idTiendaFK = t.idTienda " + "WHERE idCompra = " + id;
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				c = new Compra(rs.getInt("idCompra"), rs.getString("fechaCompra"), rs.getDouble("importeCompra"),
						rs.getString("nombreTienda"));
			}
		} catch (SQLException e) {
		} finally {
			desconectar();
		}
		return c;
	}

	public void actualizarCompra(int id, String fecha, double importe, int idTienda) {
	    
	    String sql = "UPDATE compras SET fechaCompra='" + fecha + "', " +
	                 "importeCompra=" + importe + ", " +
	                 "idTiendaFK=" + idTienda + " " +
	                 "WHERE idCompra=" + id;
	    try {
	        conectar();
	        stmt = conn.createStatement();
	        stmt.executeUpdate(sql);
	    } catch (SQLException e) {
	        System.out.println("Error al actualizar: " + e.getMessage());
	    } finally {
	        desconectar();
	    }
	}

	public List<Tienda> obtenerNombresTiendas() {
		List<Tienda> lista = new ArrayList<>();
		String sql = "SELECT idTienda, nombreTienda FROM tiendas ORDER BY nombreTienda ASC";
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				// Guardamos [ "1", "Mercadona" ]
				lista.add(new Tienda ( rs.getInt("idTienda"), rs.getString("nombreTienda") ));
			}
		} catch (SQLException e) {
			System.out.println("Error al listar tiendas: " + e.getMessage());
		} finally {
			desconectar();
		}
		return lista;
	}

	// Método para insertar la compra
	public void insertarCompra(String fecha, double importe, int idTienda, int idUsuario) {
		String sql = "INSERT INTO compras (fechaCompra, importeCompra, idTiendaFK, idUsuariosFK) VALUES " + "('" + fecha
				+ "', " + importe + ", " + idTienda + ", " + idUsuario + ")";
		try {
			conectar();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			System.out.println("Error al insertar compra: " + e.getMessage());
		} finally {
			desconectar();
		}
	}

	// Insertar nueva tienda
	public void insertarTienda(String nombre) {
		String sql = "INSERT INTO tiendas (nombreTienda) VALUES ('" + nombre + "')";
		try {
			conectar();
			stmt = conn.createStatement();
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			System.out.println("Error al insertar tienda: " + e.getMessage());
		} finally {
			desconectar();
		}
	}
	
	public void actualizarTienda(int id, String nombre) {
	    String sql = "UPDATE tiendas SET nombreTienda='" + nombre + "' WHERE idTienda=" + id;
	    try {
	        conectar();
	        stmt = conn.createStatement();
	        stmt.executeUpdate(sql);
	    } catch (SQLException e) { System.out.println(e.getMessage()); }
	    finally { desconectar(); }
	}

	public boolean eliminarTienda(int id) {
	    String sql = "DELETE FROM tiendas WHERE idTienda = " + id;
	    try {
	        conectar();
	        stmt = conn.createStatement();
	        stmt.executeUpdate(sql);
	        return true; // Borrado con éxito
	    } catch (SQLException e) {
	        // El código de error 1451 es el de restricción de clave foránea en MySQL
	        System.out.println("No se puede borrar: tiene compras asociadas.");
	        return false; 
	    } finally {
	        desconectar();
	    }
	}

	public List<Compra> obtenerComprasPorMes(int idUsuario, String mesAnio) {
		List<Compra> lista = new ArrayList<>();
		// mesAnio vendrá en formato "2023-01" desde el select
		String sql = "SELECT idCompra, DATE_FORMAT(fechaCompra, '%d/%m/%Y') AS fechaFormateada, "
				+ "importeCompra, t.nombreTienda " + "FROM compras c INNER JOIN tiendas t ON c.idTiendaFK = t.idTienda "
				+ "WHERE c.idUsuariosFK = " + idUsuario + " " + "AND DATE_FORMAT(c.fechaCompra, '%Y-%m') = '" + mesAnio
				+ "' " + "ORDER BY c.fechaCompra DESC";
		try {
			conectar();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				lista.add(new Compra(rs.getInt("idCompra"), rs.getString("fechaFormateada"),
						rs.getDouble("importeCompra"), rs.getString("nombreTienda")));
			}
		} catch (SQLException e) {
			System.out.println("Error informes: " + e.getMessage());
		} finally {
			desconectar();
		}
		return lista;
	}

	public List<String[]> obtenerMesesConCompras(int idUsuario) {
		List<String[]> meses = new ArrayList<>();
		// Usamos DISTINCT para no repetir meses y DATE_FORMAT para el value y el texto
		String sql = "SELECT DISTINCT DATE_FORMAT(fechaCompra, '%Y-%m') AS fecha1, "
				+ "DATE_FORMAT(fechaCompra, '%M %Y') AS fecha2 " + "FROM compras WHERE idUsuariosFK = " + idUsuario
				+ " " + "ORDER BY fecha1 DESC";
		try {
			conectar();
			stmt = conn.createStatement();
			stmt.execute("SET lc_time_names = 'es_ES'");
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				// Guardamos el valor (2024-03) y el texto (March 2024)
				meses.add(new String[] { rs.getString("fecha1"), rs.getString("fecha2") });
			}
		} catch (SQLException e) {
			System.out.println("Error al obtener meses: " + e.getMessage());
		} finally {
			desconectar();
		}
		return meses;
	}
}