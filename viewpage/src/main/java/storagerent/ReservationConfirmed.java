package storagerent;

public class ReservationConfirmed extends AbstractEvent {

    private Long reservationId;
    private Long storageId;
    private String reservationStatus;
    private Long paymentId;
    
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

  
}