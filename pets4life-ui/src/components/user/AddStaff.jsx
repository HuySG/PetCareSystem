import React, { useState } from 'react'
import SideBar from '../Sidebar';
import Header from '../Header';
import customerService from '../../services/customer.service'
import storage from '../../firebaseConfig';
import { ref, uploadBytesResumable, getDownloadURL } from "firebase/storage";

const AddStaff = () => {


    const [customer, setStaff] = useState({
        fullName: "",
        phone: "",
        dateOfBirth: "",
        gender: false,
        email: "",
        address: "",
        isStaff: true
    });



    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState("");



    const handleChange = (e) => {
        const value = e.target.value;
        if(customer.gender === "true"){
            customer.gender = true
        }
        if(customer.gender === "false"){
            customer.gender = false
        }
        setStaff({ ...customer, [e.target.name]: value });
    }

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
            customerService
                .saveStaff(customer)
                .then((res) => {
                    console.log(customer);
                    setMsg('Staff Added Successfully');
                })
                .catch((error) => {
                    console.log(customer);
                    console.log(error);
                });
        }
    }

    return (
        <>
            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                {/* Content Wrapper */}

                <div id="content-wrapper" class="d-flex flex-column" style={{ backgroundImage: `url(/banner2.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    {/* Main Content */}

                    <div id="content">
                        <Header />
                        <div class="container-fluid">

                            {/* Page Heading */}

                            <h1 className="h3 mb-2" style={{ fontWeight: "revert" , color: "#000", fontSize: "20px"}}>Add Staff</h1>

                            {
                                msg && <p className='text-center text-success'>
                                    {msg}
                                </p>
                            }


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
                                            <option value="true">Male</option>
                                            <option value="false">Female</option>
                                        </select>


                                    </div>


                                    <button type="submit" className="btn btn-primary">Save</button>
                                </div>
                            </form>


                        </div>
                    </div>
                </div>
            </div>
        </>

    )
}

export default AddStaff