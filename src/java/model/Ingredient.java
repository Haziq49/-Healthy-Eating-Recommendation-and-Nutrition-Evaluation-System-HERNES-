package model;

public class Ingredient {

    private int ingredientId;
    private String ingredientName;
    private double quantity;
    private String unit;
    private double energyPer100g;
    private double proteinPer100g;
    private double fatPer100g;
    private double carbPer100g;
    private double quantityInGram;
    private double totalEnergy;
    private double totalProtein;
    private double totalFat;
    private double totalCarb;

    public int getIngredientId() {
        return ingredientId;
    }

    public void setIngredientId(int ingredientId) {
        this.ingredientId = ingredientId;
    }

    public String getIngredientName() {
        return ingredientName;
    }

    public void setIngredientName(String ingredientName) {
        this.ingredientName = ingredientName;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getEnergyPer100g() {
        return energyPer100g;
    }

    public void setEnergyPer100g(double energyPer100g) {
        this.energyPer100g = energyPer100g;
    }

    public double getProteinPer100g() {
        return proteinPer100g;
    }

    public void setProteinPer100g(double proteinPer100g) {
        this.proteinPer100g = proteinPer100g;
    }

    public double getFatPer100g() {
        return fatPer100g;
    }

    public void setFatPer100g(double fatPer100g) {
        this.fatPer100g = fatPer100g;
    }

    public double getCarbPer100g() {
        return carbPer100g;
    }

    public void setCarbPer100g(double carbPer100g) {
        this.carbPer100g = carbPer100g;
    }

    public double getQuantityInGram() {
        return quantityInGram;
    }

    public void setQuantityInGram(double quantityInGram) {
        this.quantityInGram = quantityInGram;
    }

    public double getTotalEnergy() {
        return totalEnergy;
    }

    public void setTotalEnergy(double totalEnergy) {
        this.totalEnergy = totalEnergy;
    }

    public double getTotalProtein() {
        return totalProtein;
    }

    public void setTotalProtein(double totalProtein) {
        this.totalProtein = totalProtein;
    }

    public double getTotalFat() {
        return totalFat;
    }

    public void setTotalFat(double totalFat) {
        this.totalFat = totalFat;
    }

    public double getTotalCarb() {
        return totalCarb;
    }

    public void setTotalCarb(double totalCarb) {
        this.totalCarb = totalCarb;
    }
}
