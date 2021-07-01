package storagerent;
import lombok.Data;

@Data
public class ReservationCancelled extends AbstractEvent {

    private Long reservationId;
    private Long storageId;
    private String reservationStatus;
    private Long paymentId;   
}