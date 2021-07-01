package storagerent;
import lombok.Data;

@Data

public class PaymentApproved extends AbstractEvent {

    private Long paymentId;
    private Long reservationId;
    private Long storageId;
    private String paymentStatus;
    private Float price; 
}