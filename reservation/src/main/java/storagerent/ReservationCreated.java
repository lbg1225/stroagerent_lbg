package storagerent;
import lombok.Data;

@Data
public class ReservationCreated extends AbstractEvent {

    private Long reservationId;
    private Long storageId;
    private String reservationStatus;
    private Long paymentId;
    private Float price;   
}
