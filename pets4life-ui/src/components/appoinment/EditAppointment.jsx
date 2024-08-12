import React, { useEffect, useState } from 'react';
import SideBar from '../Sidebar';
import Header from '../Header';
import { useNavigate, useParams } from 'react-router-dom';
import appointmentService from '../../services/appointment.service';
import veterinarianService from '../../services/veterinarian.service';

const EditAppointment = () => {
    const [appointment, setAppointment] = useState({
        vetId: '',
        appointmentDate: "",
        notes: ""
    });

    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState('');
    const navigate = useNavigate();

    const [vetList, setVetList] = useState([]);
    useEffect(() => {
        veterinarianService
            .getAllVeterinarian()
            .then((res) => {
                console.log(res.data);
                setVetList(res.data);

            })
            .catch((error) => {
                console.log(error);
            });
    }, []);

    const [vet, setVet] = useState({
        vetId: "",
        fullName: ""
    });

    const handleChange = (e) => {
        const value = e.target.value;
        setAppointment({ ...appointment, [e.target.name]: value });

    };

    const { appointmentId } = useParams();

    useEffect(() => {
        if (appointmentId) {
            appointmentService
                .getAppointmentById(appointmentId)
                .then((res) => {
                    console.log('day la Appointment: ', res.data);
                    // Format the date to YYYY-MM-DD
                    setAppointment(res.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }, [appointmentId]);

    const validateForm = () => {
        let isValid = true;
        const errors = {};


        if (!appointment.appointmentDate || appointment.appointmentDate.trim() === '') {
            errors.appointmentDate = 'Appointment Date is required';
            isValid = false;
        }

        setErrors(errors);
        return isValid;
    };



    const submitAppointment = (e) => {
        e.preventDefault();

        if (validateForm()) {
            console.log('day la Appointment: ', appointment);

            appointmentService
                .updateAppointment(appointment.appointmentId, appointment)
                .then((res) => {
                    if (appointment.notes === 'APPROVED') {
                        sendEmail(appointmentId);
                    }
                    navigate("/list_appointments/");
                })
                .catch((error) => {
                    console.log(error);
                });

        }
    };


    const sendEmail = () => {
        appointmentService.sendEmailAppointment(appointmentId);
    };
    return (
        <>
            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                <div id="content-wrapper" className="d-flex flex-column" style={{ backgroundImage: `url(/banner2.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    <div id="content">
                        <Header />
                        <div className="container-fluid">
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Update Appointment: {appointmentId}</h1>

                            <form onSubmit={(e) => submitAppointment(e)}>
                                <div>
                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Pet</label>
                                        <input type="text" name='fullName' value={appointment.petId} className='form-control'
                                            id="exampleInputEmail1" aria-describedby="emailHelp" x disabled />
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Veterinarian</label>
                                        <select
                                            name="vetId" // Change "category" to "categoryId"
                                            value={appointment.vetId}
                                            onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.vet ? 'is-invalid' : ''}`}
                                            id="exampleInputPassword1"
                                        >
                                            <option value="">Select a Vet</option>
                                            {vetList.map((c) => (
                                                <option key={c.vetId} value={c.vetId}>{c.fullName}</option>
                                            ))}
                                            {/* Add more options as needed */}
                                        </select>

                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Appointment Date</label>
                                        <input type="date" name='appointmentDate' value={appointment.appointmentDate} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.appointmentDate ? 'is-invalid' : ''}`} id="exampleInputPassword1" />
                                        {errors.appointmentDate && (
                                            <div className="invalid-feedback">{errors.appointmentDate}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Time-Slot</label>
                                        <input type="text" name='timeSlot' value={appointment.timeSlot} className='form-control'
                                            id="exampleInputEmail1" aria-describedby="emailHelp" x disabled />
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Category</label>
                                        <input type="text" name='purpose' value={appointment.purpose} className='form-control'
                                            id="exampleInputEmail1" aria-describedby="emailHelp" x disabled />
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Status</label>
                                        <select
                                            name="notes" // Change "category" to "categoryId"
                                            value={appointment.notes}
                                            onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.appointment ? 'is-invalid' : ''}`}
                                            id="exampleInputPassword1"
                                        >
                                            <option value="">Select status</option>
                                            <option value="PROCESSING">PROCESSING</option>
                                            <option value="APPROVED">APPROVED</option>
                                            <option value="REJECT">REJECT</option>
                                            <option value="DONE">DONE</option>
                                        </select>
                                    </div>


                                    <button type="submit" className="btn btn-custom" style={{ backgroundColor: "#000" }}><i class="fas fa-check-circle text-warning"></i></button>


                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
};

export default EditAppointment;