package es.studium.gestion;

public class Tienda {
	private int idTienda;
	private String nombreTienda;

	// Constructor con parámetros
	public Tienda(int idTienda, String nombreTienda) {
		this.idTienda = idTienda;
		this.nombreTienda = nombreTienda;
	}

	// Getters y Setters
	public int getIdTienda() {
		return idTienda;
	}

	public void setIdTienda(int idTienda) {
		this.idTienda = idTienda;
	}

	public String getNombreTienda() {
		return nombreTienda;
	}

	public void setNombreTienda(String nombreTienda) {
		this.nombreTienda = nombreTienda;
	}
}