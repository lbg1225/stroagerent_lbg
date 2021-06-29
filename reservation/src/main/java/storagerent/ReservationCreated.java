package storagerent;

public class ReservationCreated extends AbstractEvent {

    private Long reservationId;
    private Long storageId;
    private String reservationStatus;
    private Long paymentId;
    private Float price;
    
    public Long getReservationId() {
        return reservationId;
    }
    public void setReservationId(Long reservationId) {
        this.reservationId = reservationId;
    }
    public Long getStorageId() {
        return storageId;
    }
    public void setStorageId(Long storageId) {
        this.storageId = storageId;
    }
    public String getReservationStatus() {
        return reservationStatus;
    }
    public void setReservationStatus(String reservationStatus) {
        this.reservationStatus = reservationStatus;
    }
    public Long getPaymentId() {
        return paymentId;
    }
    public void setPaymentId(Long paymentId) {
        this.paymentId = paymentId;
    }
    public Float getPrice() {
        return price;
    }
    public void setPrice(Float price) {
        this.price = price;
    }

    
}
