package storagerent;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface StorageviewRepository extends CrudRepository<Storageview, Long> {
    List<Storageview> findByReservationId(Long reservationId);
    List<Storageview> findByPaymentId(Long paymentId);

}