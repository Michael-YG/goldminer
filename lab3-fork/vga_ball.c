/* * Device driver for the VGA video generator
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
 * insmod vga_ball.ko
 *
 * Check code style with
 * checkpatch.pl --file --no-tree vga_ball.c
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
#include "vga_ball.h"

#define DRIVER_NAME "vga_ball"

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

/*
 * Information about our device
 */
struct vga_ball_dev {
	struct resource res; /* Resource: our registers */
	void __iomem *virtbase; /* Where registers can be accessed in memory */
        vga_ball_input_t input;
	vga_ball_hash_t hash;
} dev;

/*
 * Write segments of a single digit
 * Assumes digit is in range and the device information has been set up
 */

static void write_input(vga_ball_input_t *input)
{
	iowrite32(input->w0, W0(dev.virtbase) );
	iowrite32(input->w1, W1(dev.virtbase) );
	iowrite32(input->w2, W2(dev.virtbase) );
	iowrite32(input->w3, W3(dev.virtbase) );
	iowrite32(input->w4, W4(dev.virtbase) );
	iowrite32(input->w5, W5(dev.virtbase) );
	iowrite32(input->w6, W6(dev.virtbase) );
	iowrite32(input->w7, W7(dev.virtbase) );
	iowrite32(input->w8, W8(dev.virtbase) );
	iowrite32(input->w9, W9(dev.virtbase) );
	iowrite32(input->w10, W10(dev.virtbase) );
	iowrite32(input->w11, W11(dev.virtbase) );
	iowrite32(input->w12, W12(dev.virtbase) );
	iowrite32(input->w13, W13(dev.virtbase) );
	iowrite32(input->w14, W14(dev.virtbase) );
	iowrite32(input->w15, W15(dev.virtbase) );
}

static void read_done(unsigned *done)
{
	*done = ioread32(DONE(dev.virtbase));
}

static void read_hash(vga_ball_hash_t *hash)
{
	hash->h0 = ioread32(H0(dev.virtbase));
	hash->h1 = ioread32(H1(dev.virtbase));
	hash->h2 = ioread32(H2(dev.virtbase));
	hash->h3 = ioread32(H3(dev.virtbase));
	hash->h4 = ioread32(H4(dev.virtbase));
	hash->h5 = ioread32(H5(dev.virtbase));
	hash->h6 = ioread32(H6(dev.virtbase));
	hash->h7 = ioread32(H7(dev.virtbase));
}

/*
 * Handle ioctl() calls from userspace:
 * Read or write the segments on single digits.
 * Note extensive error checking of arguments
 */
static long vga_ball_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
	vga_ball_arg_t vla;

	switch (cmd) {
	case VGA_BALL_WRITE_INPUT:
		if (copy_from_user(&vla, (vga_ball_arg_t *) arg,
				   sizeof(vga_ball_arg_t)))
			return -EACCES;
		write_input(&vla.input);
		break;

	case VGA_BALL_READ_DONE:
		read_done(&vla.done);
		if (copy_to_user((vga_ball_arg_t *) arg, &vla,
				 sizeof(vga_ball_arg_t)))
			return -EACCES;
		break;

	case VGA_BALL_READ_HASH:
		read_hash(&vla.hash);
		if (copy_to_user((vga_ball_arg_t *) arg, &vla,
				 sizeof(vga_ball_arg_t)))
			return -EACCES;
		break;
	default:
		return -EINVAL;
	}

	return 0;
}

/* The operations our device knows how to do */
static const struct file_operations vga_ball_fops = {
	.owner		= THIS_MODULE,
	.unlocked_ioctl = vga_ball_ioctl,
};

/* Information about our device for the "misc" framework -- like a char dev */
static struct miscdevice vga_ball_misc_device = {
	.minor		= MISC_DYNAMIC_MINOR,
	.name		= DRIVER_NAME,
	.fops		= &vga_ball_fops,
};

/*
 * Initialization code: get resources (registers) and display
 * a welcome message
 */
static int __init vga_ball_probe(struct platform_device *pdev)
{
        //vga_ball_color_t beige = { 0x00, 0xff, 0x00 };
        //vga_ball_position_t pos = { 0x00, 0x04, 0x00, 0x04 };
	int ret;

	/* Register ourselves as a misc device: creates /dev/vga_ball */
	ret = misc_register(&vga_ball_misc_device);

	/* Get the address of our registers from the device tree */
	ret = of_address_to_resource(pdev->dev.of_node, 0, &dev.res);
	if (ret) {
		ret = -ENOENT;
		goto out_deregister;
	}

	/* Make sure we can use these registers */
	if (request_mem_region(dev.res.start, resource_size(&dev.res),
			       DRIVER_NAME) == NULL) {
		ret = -EBUSY;
		goto out_deregister;
	}

	/* Arrange access to our registers */
	dev.virtbase = of_iomap(pdev->dev.of_node, 0);
	if (dev.virtbase == NULL) {
		ret = -ENOMEM;
		goto out_release_mem_region;
	}
        
	/* Set an initial color */
        //write_background(&beige);
	/* Set an initial position */
        //write_position(&pos);

	return 0;

out_release_mem_region:
	release_mem_region(dev.res.start, resource_size(&dev.res));
out_deregister:
	misc_deregister(&vga_ball_misc_device);
	return ret;
}

/* Clean-up code: release resources */
static int vga_ball_remove(struct platform_device *pdev)
{
	iounmap(dev.virtbase);
	release_mem_region(dev.res.start, resource_size(&dev.res));
	misc_deregister(&vga_ball_misc_device);
	return 0;
}

/* Which "compatible" string(s) to search for in the Device Tree */
#ifdef CONFIG_OF
static const struct of_device_id vga_ball_of_match[] = {
	{ .compatible = "csee4840,vga_ball-1.0" },
	{},
};
MODULE_DEVICE_TABLE(of, vga_ball_of_match);
#endif

/* Information for registering ourselves as a "platform" driver */
static struct platform_driver vga_ball_driver = {
	.driver	= {
		.name	= DRIVER_NAME,
		.owner	= THIS_MODULE,
		.of_match_table = of_match_ptr(vga_ball_of_match),
	},
	.remove	= __exit_p(vga_ball_remove),
};

/* Called when the module is loaded: set things up */
static int __init vga_ball_init(void)
{
	pr_info(DRIVER_NAME ": init\n");
	return platform_driver_probe(&vga_ball_driver, vga_ball_probe);
}

/* Calball when the module is unloaded: release resources */
static void __exit vga_ball_exit(void)
{
	platform_driver_unregister(&vga_ball_driver);
	pr_info(DRIVER_NAME ": exit\n");
}

module_init(vga_ball_init);
module_exit(vga_ball_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Stephen A. Edwards, Columbia University");
MODULE_DESCRIPTION("VGA ball driver");
