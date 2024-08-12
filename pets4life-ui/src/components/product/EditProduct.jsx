import React, { useEffect, useState } from 'react';
import SideBar from '../Sidebar';
import Header from '../Header';
import productService from '../../services/product.service'
import storage from '../../firebaseConfig';
import { ref, uploadBytesResumable, getDownloadURL } from "firebase/storage";
import { useNavigate, useParams } from 'react-router-dom';

const EditProduct = () => {
    const [product, setProduct] = useState({
        productId: '',
        productName: "",
        brand: "",
        price: "",
        description: "",
        quantity: "",
        image: ""
    });

    const [errors, setErrors] = useState({});
    const [msg, setMsg] = useState('');
    const navigate = useNavigate();

    // Image preview
    const [imagePreview, setImagePreview] = useState(null);

    const [showImage, setShowImage] = useState(true); // Initially, show the image


    //image
    const [file, setFile] = useState("");
    // progress
    const [percent, setPercent] = useState(0);

    // Handle file upload event and update state
    function handleImageChange(event) {
        const selectedFile = event.target.files[0];
        setFile(selectedFile);
        // product.image = event.target.files[0]
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

                        product.image = link;

                        // Hide the image after uploading
                        setShowImage(false);

                    })
                    .catch((error) => {
                        console.error("Error getting download URL:", error);
                    });
            }
        );
    };

    const handleChange = (e) => {
        const value = e.target.value;
        setProduct({ ...product, [e.target.name]: value });
    };

    const { productId } = useParams();

    useEffect(() => {
        if (productId) {
            productService
                .getProductById(productId)
                .then((res) => {
                    res.data.price = res.data.price.toString();
                    res.data.quantity = res.data.quantity.toString();
                    setProduct(res.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }, [productId]);

    const validateForm = () => {
        let isValid = true;
        const errors = {};

        if (product.productName.trim() === '') {
            errors.productName = 'Product Name is required';
            isValid = false;
        }

        if (product.brand.trim() === '') {
            errors.brand = 'Brand is required';
            isValid = false;
        }

        if (product.description.trim() === '') {
            errors.description = 'Description is required';
            isValid = false;
        }


        if (product.price.trim() === '') {
            errors.price = 'Price is required';
            isValid = false;
        } else if (isNaN(product.price) || +product.price <= 0) {
            errors.price = 'Price should be a positive number';
            isValid = false;
        }

        if (product.quantity.trim() === '') {
            errors.quantity = 'Quantity is required';
            isValid = false;
        } else if (isNaN(product.quantity) || +product.quantity <= 0) {
            errors.quantity = 'Quantity should be a positive number';
            isValid = false;
        }


        setErrors(errors);
        return isValid;
    };



    const submitProduct = (e) => {
        e.preventDefault();

        if (validateForm()) {
            productService
                .updateProduct(product.productId, product)
                .then((res) => {
                    navigate("/list_products/");
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
                        <h1 className="h3 mb-2" style={{ fontWeight: "revert" , color: "#000", fontSize: "20px"}}>Update Product : {productId}</h1>

                            <form onSubmit={(e) => submitProduct(e)}>
                                <div>
                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Product Name</label>
                                        <input type="text" name='productName' value={product.productName} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.productName ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.productName && (
                                            <div className="invalid-feedback">{errors.productName}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Brand</label>
                                        <input type="text" name='brand' value={product.brand} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.brand ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.brand && (
                                            <div className="invalid-feedback">{errors.brand}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Price</label>
                                        <input type="number" name='price' value={product.price} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.price ? 'is-invalid' : ''}`} id="exampleInputPassword1" />
                                        {errors.price && (
                                            <div className="invalid-feedback">{errors.price}</div>
                                        )}
                                    </div>

                                    <div className="form-group">
                                        <label htmlFor="exampleInputEmail1">Description</label>
                                        <input type="text" name='description' value={product.description} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.description ? 'is-invalid' : ''
                                                }`} id="exampleInputEmail1" aria-describedby="emailHelp" x />
                                        {errors.description && (
                                            <div className="invalid-feedback">{errors.description}</div>
                                        )}
                                    </div>


                                    <div className="form-group">
                                        <label htmlFor="exampleInputPassword1">Quantity</label>
                                        <input type="number" name='quantity' value={product.quantity} onChange={(e) => handleChange(e)}
                                            className={`form-control ${errors.quantity ? 'is-invalid' : ''}`} id="exampleInputPassword1" />
                                        {errors.quantity && (
                                            <div className="invalid-feedback">{errors.quantity}</div>
                                        )}
                                    </div>


                                    {showImage && (
                                        <div className="form-group">
                                            <img src={product.image} alt={product.productName} width="100" height="100" />
                                        </div>
                                    )}


                                    <div className="form-group">
                                        <input type="file" onChange={handleImageChange} accept="/image/*" />
                                        <button type="button" className='btn btn-dark' onClick={handleUpload}><i class="fas fa-bolt"></i> Select</button>
                                        <p>{percent} "% done"</p>
                                    </div>

                                    {/* Image preview */}
                                    {imagePreview && (
                                        <div className="form-group">
                                            <img src={imagePreview} alt="Image Preview" style={{ width: 160, height: 100 }} />
                                        </div>
                                    )}
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

export default EditProduct;