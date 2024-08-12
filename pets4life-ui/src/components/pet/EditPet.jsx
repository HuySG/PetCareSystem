import React, { useEffect, useState } from 'react';
import SideBar from '../Sidebar';
import Header from '../Header';
import petService from '../../services/pet.service'
import storage from '../../firebaseConfig';
import { ref, uploadBytesResumable, getDownloadURL } from "firebase/storage";
import { useNavigate, useParams } from 'react-router-dom';

const EditPet = () => {
    const [pet, setPet] = useState({
        petId: '',
        diabetes: "",
        arthritis: "",
        vaccine: ""
    });

    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState('');
    const navigate = useNavigate();





    const handleChange = (e) => {
        const value = e.target.value;
        setPet({ ...pet, [e.target.name]: value });
    };

    const { petId } = useParams();

    useEffect(() => {
        if (petId) {
            petService
                .getPetById(petId)
                .then((res) => {
                    setPet(res.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }, [petId]);

    const validateForm = () => {
        let isValid = true;
        const errors = {};

        setErrors(errors);
        return isValid;
    };



    const submitPet = (e) => {
        e.preventDefault();

        if (validateForm()) {
            petService
                .updatePet(pet.petId, pet)
                .then((res) => {
                    navigate("/list_pets/");
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
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Update Pet Status : {petId}</h1>

                            <form onSubmit={(e) => submitPet(e)}>
                                <div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Diabetes Risk</label>
                                        <select
                                            name="diabetes"
                                            value={pet.diabetes} // Keep it as a boolean, not 'true' or 'false' string
                                            onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.diabetes ? 'is-invalid' : ''}`}
                                            id="exampleInputPassword1"
                                        >
                                            <option value="5">5%</option>
                                            <option value="10">10%</option>
                                            <option value="15">15%</option>
                                            <option value="20">20%</option>
                                            <option value="25">25%</option>
                                            <option value="30">30%</option>
                                            <option value="35">35%</option>
                                            <option value="40">40%</option>
                                            <option value="45">45%</option>
                                            <option value="50">50%</option>
                                            <option value="55">55%</option>
                                            <option value="60">60%</option>
                                            <option value="65">65%</option>
                                            <option value="70">70%</option>
                                            <option value="75">75%</option>
                                            <option value="80">80%</option>
                                            <option value="85">85%</option>
                                            <option value="90">90%</option>
                                            <option value="95">95%</option>
                                            <option value="100">100%</option>
                                        </select>
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Arthritis Risk</label>
                                        <select
                                            name="arthritis"
                                            value={pet.arthritis} // Keep it as a boolean, not 'true' or 'false' string
                                            onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.arthritis ? 'is-invalid' : ''}`}
                                            id="exampleInputPassword1"
                                        >
                                            <option value="5">5%</option>
                                            <option value="10">10%</option>
                                            <option value="15">15%</option>
                                            <option value="20">20%</option>
                                            <option value="25">25%</option>
                                            <option value="30">30%</option>
                                            <option value="35">35%</option>
                                            <option value="40">40%</option>
                                            <option value="45">45%</option>
                                            <option value="50">50%</option>
                                            <option value="55">55%</option>
                                            <option value="60">60%</option>
                                            <option value="65">65%</option>
                                            <option value="70">70%</option>
                                            <option value="75">75%</option>
                                            <option value="80">80%</option>
                                            <option value="85">85%</option>
                                            <option value="90">90%</option>
                                            <option value="95">95%</option>
                                            <option value="100">100%</option>
                                        </select>
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Vaccine Time</label>
                                        <select
                                            name="vaccine"
                                            value={pet.vaccine} // Keep it as a boolean, not 'true' or 'false' string
                                            onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.vaccine ? 'is-invalid' : ''}`}
                                            id="exampleInputPassword1"
                                        >
                                            <option value="1">1 time</option>
                                            <option value="2">2 times</option>
                                            <option value="3">3 times</option>
                                            <option value="4">4 times</option>
                                            <option value="5">5 times</option>
                                            
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

export default EditPet;