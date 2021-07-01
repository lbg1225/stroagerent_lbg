package storagerent;
import lombok.Data;

@Data
public class ReservationConfirmed extends AbstractEvent {

    private Long reservationId;
    private Long storageId;
    private String reservationStatus;
    private Long paymentId; 
}