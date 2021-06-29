package storagerent;

import storagerent.config.kafka.KafkaProcessor;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.annotation.StreamListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class PolicyHandler{
    @Autowired PaymentRepository paymentRepository;

    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverReservationCancelRequested_CancelPayment(@Payload ReservationCancelRequested reservationCancelRequested){

        if(!reservationCancelRequested.validate()) return;

        System.out.println("\n\n##### listener CancelPayment : " + reservationCancelRequested.toJson() + "\n\n");

          // 취소시킬 payId 추출
          long paymentId = reservationCancelRequested.getPaymentId(); // 취소시킬 payId

          Optional<Payment> res = paymentRepository.findById(paymentId);
          Payment payment = res.get();

          payment.setPaymentStatus("cancelled"); // 취소 상태로 

          // DB Update
          paymentRepository.save(payment);
            
    }

    @StreamListener(KafkaProcessor.INPUT)
    public void whatever(@Payload String eventString){}


}
