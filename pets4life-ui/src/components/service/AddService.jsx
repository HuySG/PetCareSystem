import React, { useState } from 'react'
import SideBar from '../Sidebar';
import Header from '../Header';
import serviceService from '../../services/service.service'
import storage from '../../firebaseConfig';
import { ref, uploadBytesResumable, getDownloadURL } from "firebase/storage";

const AddService = () => {


    const [service, setService] = useState({
        serviceName: "",
        brand: "",
        price: "",
        description: "",
        image: ""
    });



    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState("");

    // Image preview
    const [imagePreview, setImagePreview] = useState(null);


    //image
    const [file, setFile] = useState("");
    // progress
    const [percent, setPercent] = useState(0);


    // Handle file upload event and update state
    function handleImageChange(event) {
        const selectedFile = event.target.files[0];
        setFile(selectedFile);
        // service.image = event.target.files[0]
        // handleUpload();

        // Update the image preview
        const reader = new FileReader();
        reader.onload = (e) => {
            setImagePreview(e.target.result);
        };
        reader.readAsDataURL(selectedFile);

    }

    var link = "";

    const handleUpload = () => {
        if (!file) {
            alert("Please upload an image first!");
        }

        const storageRef = ref(storage, `/files/${file.name}`);

        // progress can be paused and resumed. It also exposes progress updates.
        // Receives the storage reference and the file to upload.
        const uploadTask = uploadBytesResumable(storageRef, file);

        uploadTask.on(
            "state_changed",
            (snapshot) => {
                const percent = Math.round(
                    (snapshot.bytesTransferred / snapshot.totalBytes) * 100
                );

                // update progress
                setPercent(percent);
            },
            (err) => console.log(err),
            () => {
                // download url

                getDownloadURL(uploadTask.snapshot.ref)
                    .then((url) => {
                        console.log("File available at:", url);
                        //gan url vao link local
                        link = url;

                        service.image = link;

                    })
                    .catch((error) => {
                        console.error("Error getting download URL:", error);
                    });
            }
        );
    };

    const handleChange = (e) => {
        const value = e.target.value;
        setService({ ...service, [e.target.name]: value });
    }

    const validateForm = () => {
        let isValid = true;
        const errors = {};

        if (service.serviceName.trim() === '') {
            errors.serviceName = 'Service Name is required';
            isValid = false;
        }

        if (service.description.trim() === '') {
            errors.description = 'Description is required';
            isValid = false;
        }


        if (service.price.trim() === '') {
            errors.price = 'Price is required';
            isValid = false;
        } else if (isNaN(service.price) || +service.price <= 0) {
            errors.price = 'Price should be a positive number';
            isValid = false;
        }

        setErrors(errors);
        return isValid;
    };




    const submitService = (e) => {
        e.preventDefault();
        if (validateForm()) {
            serviceService
                .saveService(service)
                .then((res) => {
                    console.log(service);
                    setMsg('Service Added Successfully');
                })
                .catch((error) => {
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

                            <h1 className="h3 mb-2" style={{ fontWeight: "revert" , color: "#000", fontSize: "20px"}}>Add Service</h1>

                            {
                                msg && <p className='text-center text-success'>
                                    {msg}
                                </p>
                            }


                            <form onSubmit={(e) => submitService(e)}>
                                <div>
                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Service Name</label>
                                        <input type="text" name='serviceName' value={service.serviceName} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.serviceName ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.serviceName && (
                                            <div className="invalid-feedback">{errors.serviceName}</div>
                                        )}
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Price</label>
                                        <input type="number" name='price' value={service.price} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.price ? 'is-invalid' : ''}`} id="exampleInputPassword1" />
                                        {errors.price && (
                                            <div className="invalid-feedback">{errors.price}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Description</label>
                                        <input type="text" name='description' value={service.description} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.description ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.description && (
                                            <div className="invalid-feedback">{errors.description}</div>
                                        )}
                                    </div>



                                    <div className="form-group">
                                        <input type="file" onChange={handleImageChange} accept="/image/*" />
                                        <button type="button" className='btn btn-dark' onClick={handleUpload}><i class="fas fa-bolt"></i> Select</button>
                                        <p>{percent} "% done"</p>
                                    </div>

                                    {/* Image preview */}
                                    {imagePreview && (
                                        <div className="form-group">
                                            <img src={imagePreview} alt="Image Preview" style={{ maxWidth: '100px' }} />
                                        </div>
                                    )}
                                    <button type="submit" className="btn btn-custom" style={{ backgroundColor: "#000" }}><i class="fas fa-check-circle text-warning"></i></button>
                                </div>
                            </form>


                        </div>
                    </div>
                </div>
            </div>
        </>

    )
}

export default AddService