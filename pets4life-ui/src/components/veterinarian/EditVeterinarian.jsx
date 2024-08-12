import React, { useEffect, useState } from 'react';
import SideBar from '../Sidebar';
import Header from '../Header';
import { useNavigate, useParams } from 'react-router-dom';
import veterinarianService from '../../services/veterinarian.service';

const EditVeterinarian = () => {
    const [veterinarian, setVeterinarian] = useState({
        vetId: '',
        fullName: "",
        phone: "",
        email: "",
    });

    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState('');
    const navigate = useNavigate();


    const handleChange = (e) => {
        const value = e.target.value;
        setVeterinarian({ ...veterinarian, [e.target.name]: value });
    };

    const { vetId } = useParams();

    useEffect(() => {
        if (vetId) {
            veterinarianService
                .getVeterinarianById(vetId)
                .then((res) => {
                    console.log('day la Veterinarian: ', res.data);
                    // Format the date to YYYY-MM-DD
                    setVeterinarian(res.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }, [vetId]);

    const validateForm = () => {
        let isValid = true;
        const errors = {};

        if (veterinarian.fullName.trim() === '') {
            errors.fullName = 'Veterinarian Name is required';
            isValid = false;
        }


        if (veterinarian.phone.trim() === '') {
            errors.phone = 'Phone is required';
            isValid = false;
        } else if (isNaN(veterinarian.phone) || veterinarian.phone.length !== 10) {
            errors.phone = 'Phone should be a valid number with exactly 10 digits';
            isValid = false;
        }


        setErrors(errors);
        return isValid;
    };



    const submitVeterinarian = (e) => {
        e.preventDefault();

        if (validateForm()) {
            console.log('day la veterinarian: ', veterinarian);

            veterinarianService
                .updateVeterinarian(veterinarian.vetId, veterinarian)
                .then((res) => {
                    navigate("/list_veterinarians/");
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    };

    return (
        <>
            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                <div id="content-wrapper" className="d-flex flex-column" style={{ backgroundImage: `url(/banner2.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    <div id="content">
                        <Header />
                        <div className="container-fluid">
                        <h1 className="h3 mb-2" style={{ fontWeight: "revert" , color: "#000", fontSize: "20px"}}>Update Veterinarian: {vetId}</h1>


                            <form onSubmit={(e) => submitVeterinarian(e)}>
                                <div>
                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Full Name</label>
                                        <input type="text" name='fullName' value={veterinarian.fullName} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.fullName ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.fullName && (
                                            <div className="invalid-feedback">{errors.fullName}</div>
                                        )}
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Phone</label>
                                        <input type="number" name='phone' value={veterinarian.phone} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.phone ? 'is-invalid' : ''}`} id="exampleInputPassword1" />
                                        {errors.phone && (
                                            <div className="invalid-feedback">{errors.phone}</div>
                                        )}
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Email</label>
                                        <input type="email" name='email' value={veterinarian.email} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.email ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.email && (
                                            <div className="invalid-feedback">{errors.email}</div>
                                        )}
                                    </div>


                                    <button type="submit" className="btn btn-custom" style={{backgroundColor: "#000"}}><i class="fas fa-check-circle text-warning"></i></button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
};

export default EditVeterinarian;