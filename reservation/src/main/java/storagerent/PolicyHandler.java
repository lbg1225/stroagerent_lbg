package storagerent;

import storagerent.config.kafka.KafkaProcessor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.annotation.StreamListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class PolicyHandler{
    @Autowired ReservationRepository reservationRepository;

    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverPaymentApproved_ConfirmReserve(@Payload PaymentApproved paymentApproved){

        if(!paymentApproved.validate()) return;

        System.out.println("\n\n##### listener ConfirmReserve : " + paymentApproved.toJson() + "\n\n");
        updateResvationStatus(paymentApproved.getReservationId(), "reserved", paymentApproved.getPaymentId()); // Status Update
    }

    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverPaymentCancelled_ConfirmCancel(@Payload PaymentCancelled paymentCancelled){

        if(!paymentCancelled.validate()) return;

        System.out.println("\n\n##### listener ConfirmCancel : " + paymentCancelled.toJson() + "\n\n");
        updateResvationStatus(paymentCancelled.getReservationId(), "cancelled", paymentCancelled.getPaymentId()); // Status Update    
        updateResvationStatus(paymentCancelled.getReservationId(), "cancelled", paymentCancelled.getPaymentId()); // Status Update    
    }


    @StreamListener(KafkaProcessor.INPUT)
    public void whatever(@Payload String eventString){}

    private void updateResvationStatus(long reservationId, String reservationStatus, long paymentId)     {

        //------------------------------------------
        // roomId 룸 데이터의 status, lastAction 수정
        //////////////////////////////////////////////

        // Room 테이블에서 roomId의 Data 조회 -> room
        Optional<Reservation> res = reservationRepository.findById(reservationId);
        Reservation reservation = res.get();

        // room 값 수정
        reservation.setReservationStatus(reservationStatus); // status 수정 
        reservation.setPaymentId(paymentId); // payId 수정

        System.out.println("Edited status     : " + reservation.getReservationStatus());
        System.out.println("Edited payId     : " + reservation.getPaymentId());

        /////////////
        // DB Update
        /////////////
        
        reservationRepository.save(reservation);

    }

}
