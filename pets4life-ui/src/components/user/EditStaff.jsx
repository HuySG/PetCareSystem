import React, { useEffect, useState } from 'react';
import SideBar from '../Sidebar';
import Header from '../Header';
import { useNavigate, useParams } from 'react-router-dom';
import customerService from '../../services/customer.service';

const EditStaff = () => {
    const [customer, setStaff] = useState({
        userId: '',
        fullName: "",
        phone: "",
        dateOfBirth: "",
        gender: false,
        email: "",
        address: "",
        isStaff: true
    });

    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState('');
    const navigate = useNavigate();


    const handleChange = (e) => {
        const value = e.target.value;
        setStaff({ ...customer, [e.target.name]: value });
    };

    const { userId } = useParams();

    useEffect(() => {
        if (userId) {
            customerService
                .getStaffById(userId)
                .then((res) => {
                    console.log('day la staff: ', res.data);
                    // Format the date to YYYY-MM-DD
                    const formattedDate = new Date(res.data.dateOfBirth).toISOString().split('T')[0];
                    res.data.dateOfBirth = formattedDate;
                    setStaff(res.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }, [userId]);

    const validateForm = () => {
        let isValid = true;
        const errors = {};

        if (customer.fullName.trim() === '') {
            errors.fullName = 'Staff Name is required';
            isValid = false;
        }

        if (customer.address.trim() === '') {
            errors.address = 'Address is required';
            isValid = false;
        }



        if (customer.phone.trim() === '') {
            errors.phone = 'Phone is required';
            isValid = false;
        } else if (isNaN(customer.phone) || customer.phone.length !== 10) {
            errors.phone = 'Phone should be a valid number with exactly 10 digits';
            isValid = false;
        }

        if (customer.dateOfBirth.trim() === '') {
            errors.dateOfBirth = 'Date of Birth is required';
            isValid = false;
        } else {
            // Parse the entered date and today's date
            const enteredDate = new Date(customer.dateOfBirth);
            const today = new Date();

            // Compare the entered date with today's date
            if (enteredDate > today) {
                errors.dateOfBirth = 'Date of Birth cannot be in the future';
                isValid = false;
            }
        }


        setErrors(errors);
        return isValid;
    };


    const submitStaff = (e) => {
        e.preventDefault();

        if (validateForm()) {
            console.log('day la customer: ', customer);

            customerService
                .updateStaff(customer.userId, customer)
                .then((res) => {
                    navigate("/list_staffs/");
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
                        <h1 className="h3 mb-2" style={{ fontWeight: "revert" , color: "#000", fontSize: "20px"}}>Update Staff: {userId}</h1>


                            <form onSubmit={(e) => submitStaff(e)}>
                                <div>
                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Full Name</label>
                                        <input type="text" name='fullName' value={customer.fullName} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.fullName ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.fullName && (
                                            <div className="invalid-feedback">{errors.fullName}</div>
                                        )}
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Phone</label>
                                        <input type="number" name='phone' value={customer.phone} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.phone ? 'is-invalid' : ''}`} id="exampleInputPassword1" />
                                        {errors.phone && (
                                            <div className="invalid-feedback">{errors.phone}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Address</label>
                                        <input type="text" name='address' value={customer.address} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.address ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.address && (
                                            <div className="invalid-feedback">{errors.address}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Email</label>
                                        <input type="email" name='email' value={customer.email} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.email ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.email && (
                                            <div className="invalid-feedback">{errors.email}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">D.O.B</label>
                                        <input type="date" name='dateOfBirth' value={customer.dateOfBirth} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.dateOfBirth ? 'is-invalid' : ''}`} id="exampleInputPassword1" />
                                        {errors.dateOfBirth && (
                                            <div className="invalid-feedback">{errors.dateOfBirth}</div>
                                        )}
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Gender</label>
                                        <select
                                            value={customer.gender}
                                            className="form-control"
                                            id="gender"
                                            onChange={(e) => setStaff({ ...customer, gender: e.target.value })}
                                        >
                                            <option value="1">Male</option>
                                            <option value="0">Female</option>
                                        </select>


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

export default EditStaff;