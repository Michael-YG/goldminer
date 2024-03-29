/* * Device driver for SHA256 hash function
 *
 * A Platform device implemented using the misc subsystem
 *
 * Stephen A. Edwards
 * Columbia University
 *
 * References:
 * Linux source: Documentation/driver-model/platform.txt
 *               drivers/misc/arm-charlcd.c
 * http://www.linuxforu.com/tag/linux-device-drivers/
 * http://free-electrons.com/docs/
 *
 * "make" to build
 * insmod sha256.ko
 *
 * Check code style with
 * checkpatch.pl --file --no-tree sha256.c
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include "sha256.h"

#define DRIVER_NAME_0 "sha256_0"
#define DRIVER_NAME_1 "sha256_1"
#define DRIVER_NAME_2 "sha256_2"

/* Device registers */

#define W0(x) ((x))
#define W1(x) ((x)+4)
#define W2(x) ((x)+8)
#define W3(x) ((x)+12)
#define W4(x) ((x)+16)
#define W5(x) ((x)+20)
#define W6(x) ((x)+24)
#define W7(x) ((x)+28)
#define W8(x) ((x)+32)
#define W9(x) ((x)+36)
#define W10(x) ((x)+40)
#define W11(x) ((x)+44)
#define W12(x) ((x)+48)
#define W13(x) ((x)+52)
#define W14(x) ((x)+56)
#define W15(x) ((x)+60)

#define H0(x) ((x))
#define H1(x) ((x)+4)
#define H2(x) ((x)+8)
#define H3(x) ((x)+12)
#define H4(x) ((x)+16)
#define H5(x) ((x)+20)
#define H6(x) ((x)+24)
#define H7(x) ((x)+28)

#define DONE(x) ((x)+60)
#define RESET(x) ((x)+124)

static int init_device_count = 0;
static int remove_device_count = 0;

/*
 * Information about our device
 */
struct sha256_dev {
	struct resource res; /* Resource: our registers */
	void __iomem *virtbase; /* Where registers can be accessed in memory */
} dev[3];

/*
 * Write segments of a single digit
 * Assumes digit is in range and the device information has been set up
 */

static void write_input(sha256_input *input, int device_index)
{
	iowrite32(input->w0, W0(dev[device_index].virtbase) );
	iowrite32(input->w1, W1(dev[device_index].virtbase) );
	iowrite32(input->w2, W2(dev[device_index].virtbase) );
	iowrite32(input->w3, W3(dev[device_index].virtbase) );
	iowrite32(input->w4, W4(dev[device_index].virtbase) );
	iowrite32(input->w5, W5(dev[device_index].virtbase) );
	iowrite32(input->w6, W6(dev[device_index].virtbase) );
	iowrite32(input->w7, W7(dev[device_index].virtbase) );
	iowrite32(input->w8, W8(dev[device_index].virtbase) );
	iowrite32(input->w9, W9(dev[device_index].virtbase) );
	iowrite32(input->w10, W10(dev[device_index].virtbase) );
	iowrite32(input->w11, W11(dev[device_index].virtbase) );
	iowrite32(input->w12, W12(dev[device_index].virtbase) );
	iowrite32(input->w13, W13(dev[device_index].virtbase) );
	iowrite32(input->w14, W14(dev[device_index].virtbase) );
	iowrite32(input->w15, W15(dev[device_index].virtbase) );
}

static void read_done(unsigned *done, int device_index)
{
	*done = ioread32(DONE(dev[device_index].virtbase));
}

static void read_hash(sha256_hash *hash, int device_index)
{
	hash->h0 = ioread32(H0(dev[device_index].virtbase));
	hash->h1 = ioread32(H1(dev[device_index].virtbase));
	hash->h2 = ioread32(H2(dev[device_index].virtbase));
	hash->h3 = ioread32(H3(dev[device_index].virtbase));
	hash->h4 = ioread32(H4(dev[device_index].virtbase));
	hash->h5 = ioread32(H5(dev[device_index].virtbase));
	hash->h6 = ioread32(H6(dev[device_index].virtbase));
	hash->h7 = ioread32(H7(dev[device_index].virtbase));
}

static void reset(int device_index)
{
    unsigned reset = 1;
	iowrite32(reset, RESET(dev[device_index].virtbase) );
}

/*
 * Handle ioctl() calls from userspace:
 * Read or write the segments on single digits.
 * Note extensive error checking of arguments
 */
static long sha256_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
	sha256_arg vla;

	switch (cmd) {
	case WRITE_INPUT_0:
		if (copy_from_user(&vla, (sha256_arg *) arg,
				   sizeof(sha256_arg)))
			return -EACCES;
		write_input(&vla.input, 0);
		break;

	case WRITE_INPUT_1:
		if (copy_from_user(&vla, (sha256_arg *) arg,
				   sizeof(sha256_arg)))
			return -EACCES;
		write_input(&vla.input, 1);
		break;

	case WRITE_INPUT_2:
		if (copy_from_user(&vla, (sha256_arg *) arg,
				   sizeof(sha256_arg)))
			return -EACCES;
		write_input(&vla.input, 2);
		break;

	case READ_DONE_0:
		read_done(&vla.done, 0);
		if (copy_to_user((sha256_arg *) arg, &vla,
				 sizeof(sha256_arg)))
			return -EACCES;
		break;

	case READ_DONE_1:
		read_done(&vla.done, 1);
		if (copy_to_user((sha256_arg *) arg, &vla,
				 sizeof(sha256_arg)))
			return -EACCES;
		break;

	case READ_DONE_2:
		read_done(&vla.done, 2);
		if (copy_to_user((sha256_arg *) arg, &vla,
				 sizeof(sha256_arg)))
			return -EACCES;
		break;

	case READ_HASH_0:
		read_hash(&vla.hash, 0);
		if (copy_to_user((sha256_arg *) arg, &vla,
				 sizeof(sha256_arg)))
			return -EACCES;
		break;

	case READ_HASH_1:
		read_hash(&vla.hash, 1);
		if (copy_to_user((sha256_arg *) arg, &vla,
				 sizeof(sha256_arg)))
			return -EACCES;
		break;

	case READ_HASH_2:
		read_hash(&vla.hash, 2);
		if (copy_to_user((sha256_arg *) arg, &vla,
				 sizeof(sha256_arg)))
			return -EACCES;
		break;

	case RESET_0:
		reset(0);
		break;

	case RESET_1:
		reset(1);
		break;

	case RESET_2:
		reset(2);
		break;

	default:
		return -EINVAL;
	}

	return 0;
}

/* The operations our device knows how to do */
static const struct file_operations sha256_fops = {
	.owner		= THIS_MODULE,
	.unlocked_ioctl = sha256_ioctl,
};

/* Information about our device for the "misc" framework -- like a char dev */
static struct miscdevice sha256_misc_device[] = {
	{
	.minor		= MISC_DYNAMIC_MINOR,
	.name		= DRIVER_NAME_0,
	.fops		= &sha256_fops,
	},
	{
	.minor		= MISC_DYNAMIC_MINOR,
	.name		= DRIVER_NAME_1,
	.fops		= &sha256_fops,
	},
	{
	.minor		= MISC_DYNAMIC_MINOR,
	.name		= DRIVER_NAME_2,
	.fops		= &sha256_fops,
	}
};

/*
 * Initialization code: get resources (registers) and display
 * a welcome message
 */
static int __init sha256_probe(struct platform_device *pdev)
{
	int ret;
	char *driver_names[] = {
		DRIVER_NAME_0,
		DRIVER_NAME_1,
		DRIVER_NAME_2,
	};

	/* Register ourselves as a misc device: creates /dev/sha256 */
	ret = misc_register(&sha256_misc_device[init_device_count]);

	/* Get the address of our registers from the device tree */
	ret = of_address_to_resource(pdev->dev.of_node, 0, &dev[init_device_count].res);
	if (ret) {
		ret = -ENOENT;
		goto out_deregister;
	}

	/* Make sure we can use these registers */
	if (request_mem_region(dev[init_device_count].res.start, resource_size(&dev[init_device_count].res),
			       driver_names[init_device_count]) == NULL) {
		ret = -EBUSY;
		goto out_deregister;
	}

	/* Arrange access to our registers */
	dev[init_device_count].virtbase = of_iomap(pdev->dev.of_node, 0);
	if (dev[init_device_count].virtbase == NULL) {
		ret = -ENOMEM;
		goto out_release_mem_region;
	}
        
	/* Set an initial color */
        //write_background(&beige);
	/* Set an initial position */
        //write_position(&pos);

	init_device_count++;

	return 0;

out_release_mem_region:
	release_mem_region(dev[init_device_count].res.start, resource_size(&dev[init_device_count].res));
out_deregister:
	misc_deregister(&sha256_misc_device[init_device_count]);
	return ret;
}

/* Clean-up code: release resources */
static int sha256_remove(struct platform_device *pdev)
{
	iounmap(dev[remove_device_count].virtbase);
	release_mem_region(dev[remove_device_count].res.start, resource_size(&dev[remove_device_count].res));
	misc_deregister(&sha256_misc_device[remove_device_count]);
	remove_device_count++;
	return 0;
}

/* Which "compatible" string(s) to search for in the Device Tree */
#ifdef CONFIG_OF
static const struct of_device_id sha256_of_match[] = {
	{ .compatible = "csee4840,vga_ball-1.0" },
	{},
};

MODULE_DEVICE_TABLE(of, sha256_of_match);
#endif

/* Information for registering ourselves as a "platform" driver */
static struct platform_driver sha256_driver = {
	.driver	= {
		.name	= "sha256",
		.owner	= THIS_MODULE,
		.of_match_table = of_match_ptr(sha256_of_match),
	},
	.remove	= __exit_p(sha256_remove),
};

/* Called when the module is loaded: set things up */
static int __init sha256_init(void)
{
	int ret;
	pr_info("sha256 : init\n");

	ret = platform_driver_probe(&sha256_driver, sha256_probe);
	if (ret) {
		pr_err("failed to register sha256 driver: %d\n", ret);
		return ret;
	}

	pr_info("sha256 driver registered for %d matching devices\n", init_device_count);

	return 0;
}

/* Calball when the module is unloaded: release resources */
static void __exit sha256_exit(void)
{
	platform_driver_unregister(&sha256_driver);
	pr_info("sha256 : exit\n");
	pr_info("sha256 driver unregistered for %d matching devices\n", remove_device_count);
}

module_init(sha256_init);
module_exit(sha256_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Stephen A. Edwards, Columbia University");
MODULE_DESCRIPTION("SHA256 ball driver");
